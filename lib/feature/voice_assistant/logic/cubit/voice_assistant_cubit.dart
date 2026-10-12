import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/services/tts_service.dart';
import 'package:aleman/core/services/voice_recognition_service.dart';
import 'package:aleman/feature/voice_assistant/data/model/voice_assistant_request.dart';
import 'package:aleman/feature/voice_assistant/data/model/voice_assistant_response.dart';
import 'package:aleman/feature/voice_assistant/data/repository/voice_assistant_repository.dart';
import 'package:aleman/feature/voice_assistant/logic/cubit/voice_assistant_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoiceAssistantCubit extends Cubit<VoiceAssistantState> {
  final VoiceAssistantRepository _repository;
  final VoiceRecognitionService _voiceService;
  final TtsService _ttsService;

  static const String defaultGreeting =
      'مرحبا بك في شركة الإيمان للأعلاف! تحب أساعدك بإيه النهاردة؟';

  bool _isProcessingCommand = false;

  VoiceAssistantCubit(this._repository, this._voiceService, this._ttsService)
      : super(const VoiceAssistantState());

  /// Greet user on open and transition to listening when speech finishes
  Future<void> greetUserAndListen() async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: VoiceAssistantStatus.idle,
        isSpeaking: true,
        response: const VoiceAssistantResponse(
          success: true,
          intent: 'Greeting',
          spokenReply: defaultGreeting,
          action: 'none',
        ),
      ),
    );

    await _ttsService.speak(
      defaultGreeting,
      onDone: () {
        if (!isClosed &&
            state.status != VoiceAssistantStatus.processing &&
            !_isProcessingCommand) {
          startListening();
        }
      },
    );
  }

  /// Start voice listening
  Future<void> startListening() async {
    if (isClosed) return;
    await _ttsService.stop();

    emit(
      state.copyWith(
        status: VoiceAssistantStatus.listening,
        recognizedText: '',
        soundLevel: 0.0,
        isSpeaking: false,
      ),
    );

    final success = await _voiceService.startListening(
      onResult: (text) {
        if (!isClosed) {
          emit(state.copyWith(recognizedText: text));
        }
      },
      onSoundLevel: (level) {
        if (!isClosed) {
          emit(state.copyWith(soundLevel: (level / 10).clamp(0.0, 1.0)));
        }
      },
      onStatus: (status) {
        if (isClosed) return;
        // Process command ONLY when SpeechToText finishes ('done') to prevent duplicate requests
        if (status == 'done') {
          if (state.status == VoiceAssistantStatus.listening &&
              state.recognizedText.trim().isNotEmpty &&
              !_isProcessingCommand) {
            processCommand(state.recognizedText.trim());
          } else if (state.status == VoiceAssistantStatus.listening &&
              !_isProcessingCommand) {
            emit(state.copyWith(status: VoiceAssistantStatus.idle));
          }
        }
      },
      onError: (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: VoiceAssistantStatus.error,
              errorMessage: error,
            ),
          );
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );

    if (!success && !isClosed) {
      emit(
        state.copyWith(
          status: VoiceAssistantStatus.error,
          errorMessage: 'تعذر تشغيل الميكروفون',
        ),
      );
    }
  }

  /// Stop listening and trigger processing safely
  Future<void> stopListening() async {
    await _voiceService.stopListening();
    if (!isClosed) {
      if (state.recognizedText.trim().isNotEmpty && !_isProcessingCommand) {
        await processCommand(state.recognizedText.trim());
      } else if (!_isProcessingCommand) {
        emit(state.copyWith(status: VoiceAssistantStatus.idle));
      }
    }
  }

  /// Process text command through Backend AI
  Future<void> processCommand(String query) async {
    if (query.trim().isEmpty || _isProcessingCommand || isClosed) return;
    _isProcessingCommand = true;

    await _voiceService.stopListening();

    final cleanedQuery = cleanSpokenQuery(query.trim());

    if (!isClosed) {
      emit(
        state.copyWith(
          status: VoiceAssistantStatus.processing,
          recognizedText: cleanedQuery,
        ),
      );
    }

    try {
      final result = await _repository.processVoiceCommand(
        VoiceAssistantRequest(query: cleanedQuery),
      );

      if (isClosed) return;

      result.when(
        success: (response) {
          if (isClosed) return;
          emit(
            state.copyWith(
              status: VoiceAssistantStatus.success,
              response: response,
              isSpeaking: true,
            ),
          );

          void onSpeechDone() {
            if (!isClosed) {
              emit(state.copyWith(isSpeaking: false));
              // Auto-listen if assistant asked for confirmation
              if (response.action == 'confirm_order') {
                startListening();
              }
            }
          }

          // Speak reply out loud (via audioUrl stream if provided, or male TTS)
          if (response.audioUrl != null && response.audioUrl!.isNotEmpty) {
            _ttsService.playUrl(
              response.audioUrl!,
              onDone: onSpeechDone,
            );
          } else if (response.spokenReply.isNotEmpty) {
            _ttsService.speak(
              response.spokenReply,
              onDone: onSpeechDone,
            );
          }
        },
        failure: (apiError) {
          if (isClosed) return;
          final errorMsg = apiError.message ?? 'تعذر معالجة الطلب حالياً';
          emit(
            state.copyWith(
              status: VoiceAssistantStatus.error,
              errorMessage: errorMsg,
            ),
          );
          _ttsService.speak('عذراً، حدث خطأ في التواصل مع الخادم.');
        },
      );
    } finally {
      _isProcessingCommand = false;
    }
  }

  /// Cleans and corrects common Arabic Speech-To-Text phonetic inaccuracies:
  /// - 'ديب' -> 'ضيف' (ordering/cart context)
  /// - 'على البادي' / 'ع البادي' -> 'علف بادي'
  /// - 'على النامي' -> 'علف نامي'
  static String cleanSpokenQuery(String rawQuery) {
    var text = rawQuery.trim();
    if (text.isEmpty) return '';

    // Fix 'ديب' / 'تيب' / 'ديف' -> 'ضيف'
    text = text.replaceAll(RegExp(r'\b(ديب|تيب|ديف|ضف)\b'), 'ضيف');

    // Fix 'على [نوع علف]' -> 'علف [نوع علف]'
    text = text.replaceAll(RegExp(r'\b(على|ع)\s+(البادي|بادي)\b'), 'علف بادي');
    text = text.replaceAll(RegExp(r'\b(على|ع)\s+(النامي|نامي)\b'), 'علف نامي');
    text = text.replaceAll(RegExp(r'\b(على|ع)\s+(الناهي|ناهي)\b'), 'علف ناهي');
    text = text.replaceAll(RegExp(r'\b(على|ع)\s+(البياض|بياض)\b'), 'علف بياض');
    text = text.replaceAll(RegExp(r'\b(على|ع)\s+(الأرانب|أرانب)\b'), 'علف أرانب');
    text = text.replaceAll(RegExp(r'\b(على|ع)\s+(المواشي|مواشي)\b'), 'علف مواشي');
    text = text.replaceAll(RegExp(r'\b(على|ع)\s+(تسمين)\b'), 'علف تسمين');
    text = text.replaceAll(RegExp(r'\b(على|ع)\s+(حلاب)\b'), 'علف حلاب');

    // Convert Arabic number words to digits before sending to backend to prevent AI confusing quantity with protein %
    text = text.replaceAll(RegExp(r'\b(خمس|خمسة)\b'), '5');
    text = text.replaceAll(RegExp(r'\b(أربع|أربعة|اربع|اربعة)\b'), '4');
    text = text.replaceAll(RegExp(r'\b(ثلاث|ثلاثة|تلات|تلاتة)\b'), '3');
    text = text.replaceAll(RegExp(r'\b(شيكارتين|شكارتين)\b'), '2 شيكارة');
    text = text.replaceAll(RegExp(r'\b(اثنين|اتنين)\b'), '2');
    text = text.replaceAll(RegExp(r'\b(واحد|واحدة)\b'), '1');
    text = text.replaceAll(RegExp(r'\b(ست|ستة)\b'), '6');
    text = text.replaceAll(RegExp(r'\b(سبع|سبعة)\b'), '7');
    text = text.replaceAll(RegExp(r'\b(ثمان|ثمانية|تمان|تمانية)\b'), '8');
    text = text.replaceAll(RegExp(r'\b(تسع|تسعة)\b'), '9');
    text = text.replaceAll(RegExp(r'\b(عشر|عشرة)\b'), '10');
    text = text.replaceAll(RegExp(r'\b(عشرين)\b'), '20');
    text = text.replaceAll(RegExp(r'\b(خمسين)\b'), '50');
    text = text.replaceAll(RegExp(r'\b(مية|مائة)\b'), '100');

    // Clean up multiple spaces
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    return text;
  }

  /// Speak custom text
  Future<void> speak(String text) async {
    if (isClosed) return;
    emit(state.copyWith(isSpeaking: true));
    await _ttsService.speak(text);
    if (!isClosed) {
      emit(state.copyWith(isSpeaking: false));
    }
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    await _ttsService.stop();
    if (!isClosed) {
      emit(state.copyWith(isSpeaking: false));
    }
  }

  /// Reset to idle
  void reset() {
    _isProcessingCommand = false;
    _voiceService.stopListening();
    _ttsService.stop();
    if (!isClosed) {
      emit(const VoiceAssistantState());
    }
  }

  @override
  Future<void> close() {
    _isProcessingCommand = false;
    _voiceService.stopListening();
    _ttsService.stop();
    return super.close();
  }
}
