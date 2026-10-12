import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Service responsible for Text-To-Speech and Audio playback.
/// Strictly enforces MALE voice profiles according to company policy:
/// 1. Auto-selects Google TTS Engine (com.google.android.tts) on Android for high-fidelity male voices.
/// 2. Actively searches and locks onto Arabic male voice profiles (e.g. Maged, Tarik, ar-xa-x-ard, ar-xa-x-arb).
/// 3. Blacklists all known female voice profiles (Layla, Mariam, Zariyah, ar-xa-x-ara, ar-xa-x-arc, etc.).
/// 4. Enforces an authoritative masculine acoustic pitch (0.60) and calm speech rate (0.44).
/// 5. Never calls setLanguage() inside speak() which would reset the locked male voice back to female default.
/// 6. Supports playing studio-recorded male MP3 files or backend audio streams via AudioPlayer.
class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isInitialized = false;
  bool _isSpeaking = false;
  String _selectedLanguage = 'ar-EG';
  Map<String, String>? _selectedVoice;
  bool _isMaleVoiceLocked = false;
  VoidCallback? _onCompletion;

  bool get isSpeaking => _isSpeaking;
  String get selectedLanguage => _selectedLanguage;
  bool get isMaleVoiceLocked => _isMaleVoiceLocked;

  /// Masculine acoustic parameters:
  /// Standard adult female fundamental frequency: ~210-240 Hz
  /// Standard adult male fundamental frequency: ~110-140 Hz
  /// Pitch 0.60 shifts vocal tract output down into the deep baritone range.
  static const double malePitch = 0.60;
  static const double maleSpeechRate = 0.44;

  /// Keywords identifying male Arabic voices across Android/iOS/Google/Samsung engines
  static const List<String> maleKeywords = [
    'male',
    'man',
    'maged',      // Apple iOS Arabic male voice (Saudi/Gulf)
    'tarik',      // Apple iOS Arabic male voice
    'tariq',
    'ard',        // Google TTS Arabic male (ar-xa-x-ard)
    'arb',        // Google TTS Arabic male (ar-xa-x-arb)
    'are',        // Google TTS Arabic male (ar-xa-x-are)
    'arz',        // Google TTS Arabic male (ar-xa-x-arz)
    'wavenet-b',  // Google Cloud male Wavenet
    'wavenet-d',  // Google Cloud male Wavenet
    'standard-b',
    'standard-d',
    'neural2-b',
  ];

  /// Keywords identifying female Arabic voices to strictly blacklist
  static const List<String> femaleBlacklist = [
    'female',
    'woman',
    'laila',
    'layla',
    'mariam',
    'meryem',
    'zariyah',
    'ara',        // Google TTS Arabic female (ar-xa-x-ara)
    'arc',        // Google TTS Arabic female (ar-xa-x-arc)
    'wavenet-a',
    'wavenet-c',
    'standard-a',
    'standard-c',
  ];

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 1. On Android: Try to lock onto Google TTS engine which bundles Arabic male voices
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        try {
          final dynamic rawEngines = await _flutterTts.getEngines;
          if (rawEngines is List) {
            final engines = rawEngines.map((e) => e.toString().toLowerCase()).toList();
            debugPrint('🔊 TTS Available Engines: $engines');
            if (engines.contains('com.google.android.tts')) {
              await _flutterTts.setEngine('com.google.android.tts');
              debugPrint('✅ Locked TTS Engine to Google TTS (com.google.android.tts)');
              // Allow Android TextToSpeech service connection to bind asynchronously
              await Future.delayed(const Duration(milliseconds: 400));
            }
          }
        } catch (e) {
          debugPrint('Engine selection skipped: $e');
        }
      }

      // 2. Select Arabic locale
      final dynamic rawLanguages = await _flutterTts.getLanguages;
      if (rawLanguages is List) {
        final languages = rawLanguages.map((e) => e.toString().toLowerCase()).toList();
        if (languages.any((l) => l.replaceAll('_', '-') == 'ar-eg')) {
          _selectedLanguage = 'ar-EG';
        } else if (languages.any((l) => l.replaceAll('_', '-') == 'ar-sa')) {
          _selectedLanguage = 'ar-SA';
        } else if (languages.any((l) => l.startsWith('ar'))) {
          _selectedLanguage = 'ar';
        }
      }

      // 3. Search and lock onto verified MALE voice
      try {
        final dynamic rawVoices = await _flutterTts.getVoices;
        if (rawVoices is List) {
          Map<String, String>? bestMaleVoice;
          Map<String, String>? nonFemaleVoice;

          debugPrint('🔊 Total voices available on device: ${rawVoices.length}');
          for (final v in rawVoices) {
            if (v is Map) {
              final locale = (v['locale'] ?? '').toString().toLowerCase();
              final name = (v['name'] ?? '').toString().toLowerCase();
              final gender = (v['gender'] ?? '').toString().toLowerCase();

              final isArabic = locale.startsWith('ar') || name.startsWith('ar');
              if (!isArabic) continue;

              final isFemale = femaleBlacklist.any((f) => name.contains(f) || locale.contains(f)) ||
                  gender == 'female';

              final isMale = maleKeywords.any((m) => name.contains(m) || locale.contains(m)) ||
                  gender == 'male';

              if (isMale && !isFemale) {
                bestMaleVoice = {
                  'name': v['name'].toString(),
                  'locale': v['locale'].toString(),
                };
                debugPrint('👨 Found Verified Male Arabic Voice in device list: ${v['name']}');
                break;
              } else if (!isFemale && nonFemaleVoice == null) {
                nonFemaleVoice = {
                  'name': v['name'].toString(),
                  'locale': v['locale'].toString(),
                };
              }
            }
          }

          if (bestMaleVoice != null) {
            _selectedVoice = bestMaleVoice;
            _isMaleVoiceLocked = true;
            await _flutterTts.setVoice(_selectedVoice!);
            debugPrint('✅ Applied Male Voice Profile: ${_selectedVoice!['name']}');
          } else {
            // Attempt direct candidate male voice names supported by Google Speech Services
            bool directCandidateSet = false;
            for (final candidate in [
              'ar-xa-x-ard-network',
              'ar-xa-x-ard-local',
              'ar-xa-x-arb-network',
              'ar-xa-x-arb-local',
              'ar-xa-x-are-network',
              'ar-eg-x-ard-network',
            ]) {
              try {
                await _flutterTts.setVoice({'name': candidate, 'locale': 'ar-XA'});
                _selectedVoice = {'name': candidate, 'locale': 'ar-XA'};
                _isMaleVoiceLocked = true;
                directCandidateSet = true;
                debugPrint('✅ Applied direct candidate male voice: $candidate');
                break;
              } catch (_) {}
            }

            if (!directCandidateSet && nonFemaleVoice != null) {
              _selectedVoice = nonFemaleVoice;
              await _flutterTts.setVoice(_selectedVoice!);
              debugPrint('⚠️ Selected neutral Arabic voice: ${_selectedVoice!['name']}');
            } else if (!directCandidateSet) {
              await _flutterTts.setLanguage(_selectedLanguage);
              debugPrint('⚠️ No explicit male voice profile returned by phone. Forcing deep baritone pitch ($malePitch).');
            }
          }
        }
      } catch (e) {
        debugPrint('Voice list inspection error: $e');
        await _flutterTts.setLanguage(_selectedLanguage);
      }

      // 4. Force masculine acoustic parameters
      await _flutterTts.setPitch(malePitch);
      await _flutterTts.setSpeechRate(maleSpeechRate);
      await _flutterTts.setVolume(1.0);

      // 5. Setup listeners
      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        _onCompletion?.call();
        _onCompletion = null;
      });

      _flutterTts.setErrorHandler((msg) {
        debugPrint('TTS Error: $msg');
        _isSpeaking = false;
        _onCompletion?.call();
        _onCompletion = null;
      });

      // AudioPlayer listener
      _audioPlayer.onPlayerComplete.listen((_) {
        _isSpeaking = false;
        _onCompletion?.call();
        _onCompletion = null;
      });

      _isInitialized = true;
      debugPrint('🎙️ TtsService successfully initialized with Male Voice profile.');
    } catch (e) {
      debugPrint('Failed to initialize TtsService: $e');
    }
  }

  /// Speak Arabic text with guaranteed male tone and completion callback
  Future<void> speak(String text, {VoidCallback? onDone}) async {
    if (text.trim().isEmpty) {
      onDone?.call();
      return;
    }
    if (!_isInitialized) {
      await initialize();
    }

    _onCompletion = onDone;

    try {
      await stop();

      // CRITICAL: Re-apply male voice.
      // NEVER call setLanguage() here because on Android that wipes setVoice() and resets to female default!
      if (_selectedVoice != null) {
        await _flutterTts.setVoice(_selectedVoice!);
      } else {
        await _flutterTts.setLanguage(_selectedLanguage);
      }

      final spokenText = normalizeTextForSpeech(text);

      await _flutterTts.setPitch(malePitch);
      await _flutterTts.setSpeechRate(maleSpeechRate);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.speak(spokenText);
    } catch (e) {
      debugPrint('Error in TTS speak: $e');
      onDone?.call();
    }
  }

  /// Preprocesses text for crystal-clear Egyptian spoken audio:
  /// - Converts 'ج.م', 'ج.م.', 'ج', 'EGP', 'LE' to 'جنيه'
  /// - Converts '%' to 'في المية'
  /// - Converts 'كجم', 'كغ' to 'كيلو'
  /// - Fixes words that TTS mispronounces (e.g. 'أقدر' -> 'أَقْدَر' instead of 'أُقَدِّر')
  static String normalizeTextForSpeech(String rawText) {
    if (rawText.trim().isEmpty) return '';

    var text = rawText;

    // 1. Currencies & Egyptian Pound (ج.م، ج م، ج، EGP، LE):
    // Replace 'ج.م' or 'ج.م.' or 'ج م'
    text = text.replaceAll(RegExp(r'ج\.م\.?|ج\s+م', caseSensitive: false), ' جنيه ');
    // Replace English abbreviations e.g. EGP, LE, L.E.
    text = text.replaceAll(RegExp(r'\b(EGP|LE|L\.E)\b', caseSensitive: false), ' جنيه ');
    // Replace 'ج' when adjacent to digits, e.g. "650 ج" or "650ج" or "ج 650"
    text = text.replaceAllMapped(
      RegExp(r'(\d+)\s*ج(?!\w)'),
      (m) => '${m[1]} جنيه',
    );
    text = text.replaceAllMapped(
      RegExp(r'(?<!\w)ج\s*(\d+)'),
      (m) => '${m[1]} جنيه',
    );

    // 2. Percentages (23% -> 23 في المية):
    text = text.replaceAllMapped(
      RegExp(r'(\d+)%'),
      (m) => '${m[1]} في المية',
    );
    text = text.replaceAll('%', ' في المية ');

    // 3. Weight units (كجم، كغ -> كيلو):
    text = text.replaceAll(RegExp(r'\b(كجم|كغ|ك\.ج)\b'), 'كيلو');
    text = text.replaceAllMapped(
      RegExp(r'(\d+)\s*كجم'),
      (m) => '${m[1]} كيلو',
    );

    // 4. Mispronounced Egyptian words:
    // "أقدر" is often mispronounced by TTS as "أُقَدِّر" (appreciate/value)
    text = text.replaceAll(RegExp(r'\b(أقدر|اقدر)\b'), 'أَقْدَر');
    // "شكاير" -> "شَكايِر"
    text = text.replaceAll(RegExp(r'\bشكاير\b'), 'شَكايِر');

    // 5. Clean up multiple spaces
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    return text;
  }

  /// Play pre-recorded male audio file from assets (e.g., 'sounds/male_greeting.mp3')
  Future<void> playAsset(String assetPath, {VoidCallback? onDone}) async {
    if (!_isInitialized) {
      await initialize();
    }

    _onCompletion = onDone;
    try {
      await stop();
      _isSpeaking = true;
      final cleanPath = assetPath.startsWith('assets/')
          ? assetPath.replaceFirst('assets/', '')
          : assetPath;
      await _audioPlayer.play(AssetSource(cleanPath));
    } catch (e) {
      debugPrint('Error playing asset audio: $e');
      _isSpeaking = false;
      onDone?.call();
    }
  }

  /// Play male audio from network URL (from backend / Gemini / ElevenLabs)
  Future<void> playUrl(String url, {VoidCallback? onDone}) async {
    if (!_isInitialized) {
      await initialize();
    }

    _onCompletion = onDone;
    try {
      await stop();
      _isSpeaking = true;
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      debugPrint('Error playing url audio: $e');
      _isSpeaking = false;
      onDone?.call();
    }
  }

  /// Stop current playback (TTS and AudioPlayer)
  Future<void> stop() async {
    try {
      _onCompletion = null;
      await _flutterTts.stop();
      await _audioPlayer.stop();
      _isSpeaking = false;
    } catch (e) {
      debugPrint('Error in TTS stop: $e');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
