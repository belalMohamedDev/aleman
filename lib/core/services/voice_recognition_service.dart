import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceRecognitionService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  bool _isInitialized = false;
  bool _isAvailable = false;
  bool _isArabicSupported = false;
  String? _selectedLocaleId;

  Function(String status)? _statusListener;
  Function(String error)? _errorListener;

  bool get isInitialized => _isInitialized;
  bool get isAvailable => _isAvailable;
  bool get isArabicSupported => _isArabicSupported;
  bool get isListening => _speechToText.isListening;
  String? get selectedLocaleId => _selectedLocaleId;

  /// Initialize speech engine with listeners
  Future<bool> initialize({
    Function(String status)? onStatus,
    Function(SpeechRecognitionError error)? onError,
  }) async {
    if (_isInitialized && _isAvailable) return true;

    try {
      _isAvailable = await _speechToText.initialize(
        onStatus: (status) {
          debugPrint('🎙️ Speech status: $status');
          _statusListener?.call(status);
          onStatus?.call(status);
        },
        onError: (errorNotification) {
          debugPrint('🎙️ Speech error: ${errorNotification.errorMsg} (permanent: ${errorNotification.permanent})');
          _errorListener?.call(mapErrorToHumanReadable(errorNotification.errorMsg));
          onError?.call(errorNotification);
        },
        debugLogging: true,
      );

      if (_isAvailable) {
        final locales = await _speechToText.locales();
        final systemLocale = await _speechToText.systemLocale();
        _selectedLocaleId = _resolveArabicLocale(locales, systemLocale?.localeId);
        debugPrint('🎯 Selected Speech Locale: $_selectedLocaleId (isArabic: $_isArabicSupported)');
      }

      _isInitialized = true;
      return _isAvailable;
    } catch (e) {
      debugPrint('❌ Error initializing SpeechToText: $e');
      _isAvailable = false;
      return false;
    }
  }

  /// CRITICAL FIX: Ensures ONLY Arabic locales are selected.
  /// NEVER falls back to locales.first which on many devices is zh_CN (Chinese)!
  String _resolveArabicLocale(List<stt.LocaleName> locales, String? systemLocaleId) {
    debugPrint('🔎 Searching for Arabic in ${locales.length} available locales...');
    
    // 1. Look for Egyptian Arabic (ar-EG, ar_EG)
    for (final l in locales) {
      final clean = l.localeId.toLowerCase().replaceAll('_', '-');
      if (clean == 'ar-eg') {
        _isArabicSupported = true;
        return l.localeId;
      }
    }

    // 2. Look for Saudi Arabic (ar-SA, ar_SA) - Excellent coverage
    for (final l in locales) {
      final clean = l.localeId.toLowerCase().replaceAll('_', '-');
      if (clean == 'ar-sa') {
        _isArabicSupported = true;
        return l.localeId;
      }
    }

    // 3. Look for any other Arabic dialect (ar-AE, ar-KW, ar-QA, ar, etc.)
    for (final l in locales) {
      final clean = l.localeId.toLowerCase().replaceAll('_', '-');
      if (clean.startsWith('ar-') || clean == 'ar') {
        _isArabicSupported = true;
        return l.localeId;
      }
    }

    // 4. Check if system locale is Arabic
    if (systemLocaleId != null && systemLocaleId.toLowerCase().startsWith('ar')) {
      _isArabicSupported = true;
      return systemLocaleId;
    }

    // 5. If no Arabic is installed locally in the device's offline list:
    // FORCE 'ar-EG' or 'ar-SA'!
    // Google Speech Services will use online Arabic recognition.
    // NEVER EVER use locales.first because that causes Chinese/English output!
    debugPrint('⚠️ No Arabic locale in device offline list. Forcing ar-EG tag.');
    _isArabicSupported = false;
    return 'ar-EG';
  }

  /// Check and request microphone permission
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;
    if (status.isDenied) {
      final result = await Permission.microphone.request();
      return result.isGranted;
    }
    if (status.isPermanentlyDenied) {
      return false;
    }
    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  /// Comprehensive list of Egyptian dialect, livestock, and feed industry biasing phrases.
  /// Android SpeechRecognizer (EXTRA_AUDIO_BIASING_PHRASES) and Apple Speech
  /// use these to dramatically improve speech recognition accuracy for specialized Egyptian vocab.
  static const List<String> defaultContextualPhrases = [
    // --- 1. اسم الشركة والعلامة التجارية ---
    'شركة الإيمان',
    'الإيمان للأعلاف',
    'أعلاف الإيمان',
    'مصنع الإيمان',
    'علف الإيمان',
    'الإيمان',

    // --- 2. أنواع ومراحل الأعلاف الأساسية ---
    'علف',
    'أعلاف',
    'بادي',
    'بادئ',
    'بادي سوبر',
    'نامي',
    'نامي سوبر',
    'ناهي',
    'ناهي سوبر',
    'بادي نامي',
    'بياض',
    'بياض إنتاجي',
    'بياض مرحلة أولى',
    'بياض مرحلة ثانية',
    'أمهات',
    'تسمين',
    'تحضين',
    'فطام',
    'مرضعات',
    'حلاب',
    'جاف',
    'علف مركز',
    'عليقة',
    'خلطة',

    // --- 3. أنواع الدواجن والطيور (مصطلحات المزارع المصرية) ---
    'دواجن',
    'فراخ',
    'فرخة',
    'فراخ بيضا',
    'فراخ بيضاء',
    'فراخ ساسو',
    'فراخ بلدي',
    'بلدي مشعر',
    'بلدي هجين',
    'فيومي',
    'جميزة',
    'كتاكيت',
    'كتكوت',
    'كتاكيت أبيض',
    'كتاكيت ساسو',
    'بداري',
    'فروج',
    'عتاقي',
    'بط',
    'بط مسكوفي',
    'بط مولار',
    'بط فرنساوي',
    'بط بكيني',
    'بط بلدي',
    'وز',
    'رومي',
    'ديك رومي',
    'طيور',
    'سمان',
    'حمام',
    'زغاليل',

    // --- 4. أنواع المواشي والحيوانات والأسماك ---
    'مواشي',
    'بهائم',
    'أبقار',
    'بقر',
    'بقري',
    'جاموس',
    'جاموسي',
    'عجول',
    'عجل',
    'تسمين عجول',
    'عجول بقري',
    'عجول جاموسي',
    'طلوقة',
    'حلوب',
    'خراف',
    'خرفان',
    'غنم',
    'نعاج',
    'كباش',
    'ماعز',
    'معيز',
    'جديان',
    'أرانب',
    'أرنب',
    'خلفة',
    'أمهات أرانب',
    'ذكور أرانب',
    'خيول',
    'حصان',
    'خيل',
    'أسماك',
    'سمك',
    'بلطي',
    'بوري',
    'جمبري',
    'أعلاف أسماك',

    // --- 5. نسب البروتين والأرقام باللهجة المصرية والفصحى ---
    'بروتين',
    'نسبة بروتين',
    'بروتين 23%',
    'بروتين 21%',
    'بروتين 19%',
    'بروتين 18%',
    'بروتين 16%',
    'بروتين 14%',
    'بروتين 12%',
    '23%',
    '21%',
    '19%',
    '18%',
    '16%',
    '14%',
    '24%',
    '22%',
    '20%',
    'تلاتة وعشرين',
    'ثلاثة وعشرين',
    'واحد وعشرين',
    'تسعتاشر',
    'تسعة عشر',
    'تمانتاشر',
    'ثمانية عشر',
    'سبعتاشر',
    'سبعة عشر',
    'سطاشر',
    'ستة عشر',
    'خمستاشر',
    'خمسة عشر',
    'أربعتاشر',
    'أربعة عشر',
    'اتنين وعشرين',
    'أربعة وعشرين',
    'في المية',

    // --- 6. هيئة وقوام العلف والمكونات ---
    'مفتت',
    'محبب',
    'بيلت',
    'ناعم',
    'خشن',
    'بودرة',
    'صوابع',
    'حبة كاملة',
    'طافي',
    'غاطس',
    'كسب صويا',
    'ذرة صفراء',
    'ردة',
    'نخالة',
    'دريس',
    'أملاح معدنية',
    'فيتامينات',
    'مضاد سموم',
    'خمائر',

    // --- 7. وحدات القياس والتعبئة والكميات ---
    'شيكارة',
    'شكارة',
    'شيكاره',
    'شكاره',
    'شكاير',
    'شيكارات',
    'شيكارتين',
    'شكارتين',
    'طن',
    'طنين',
    'أطنان',
    'نص طن',
    'ربع طن',
    'كيلو',
    'كيلوات',
    'كيلوجرام',
    '25 كيلو',
    '50 كيلو',
    'خمسين كيلو',
    'خمسة وعشرين كيلو',
    'نقلة',
    'عربية',
    'حمولة',

    // --- 8. أوامر الشراء والطلب والسلة (عامية وفصحى) ---
    'أوردر',
    'طلب',
    'طلبية',
    'عايز',
    'عاوز',
    'محتاج',
    'اشتري',
    'أشتري',
    'هاتلي',
    'ابعتلي',
    'احجزلي',
    'اطلبلي',
    'سلة',
    'السلة',
    'عربة التسوق',
    'الكارت',
    'ضيف للسلة',
    'ضيف إلى السلة',
    'حط في السلة',
    'حط في الكارت',
    'شيل من السلة',
    'امسح السلة',
    'احذف من السلة',
    'إتمام الطلب',
    'تأكيد الطلب',
    'عمل أوردر',
    'كنسل',
    'إلغاء الطلب',

    // --- 9. الأسعار والبورصة والحسابات ---
    'بكام',
    'كام',
    'السعر',
    'سعر',
    'الأسعار',
    'أسعار',
    'سعر الشيكارة',
    'سعر الطن',
    'أسعار الأعلاف',
    'بورصة العلف',
    'بورصة الدواجن',
    'أسعار اليوم',
    'أسعار النهاردة',
    'قايمة الأسعار',
    'كشف حساب',
    'حسابي',
    'رصيدي',
    'مديونية',
    'خصم',
    'عروض',
    'تخفيض',

    // --- 10. الشحن والتوصيل والعناوين والدفع ---
    'توصيل',
    'دليفري',
    'شحن',
    'مصاريف الشحن',
    'شحنتي',
    'فين شحنتي',
    'فين طلبي',
    'تتبع الطلب',
    'تتبع الشحنة',
    'الأوردر وصل فين',
    'هيوصل إمتى',
    'كاش',
    'نقدي',
    'الدفع عند الاستلام',
    'فيزا',
    'محفظة',
    'فودافون كاش',
    'فوري',
    'مزرعة',
    'عنبر',
    'مزرعتي',
    'عنبري',
    'المخزن',
    'المحل',
    'عنواني',
    'لوكيشن',

    // --- 11. نصائح التغذية والتربية البيطرية ---
    'استشارة',
    'نصيحة',
    'دكتور بيطري',
    'بيطري',
    'معامل التحويل',
    'معدل التحويل',
    'زيادة الوزن',
    'أوزان ضعيفة',
    'عمر يوم',
    'عمر أسبوع',
    'عمر أسبوعين',
    'عمر شهر',
    'تحضين الكتاكيت',
    'جدول التغذية',
    'جدول العلف',
    'استهلاك العلف',
    'سموم فطرية',
    'إسهال بني',
    'إسهال أبيض',
    'كوكسيديا',
    'كلوستريديا',
    'تهوية',
    'تدفئة',

    // --- 12. جمل عامية مركبة شائعة جداً ---
    'عايز أطلب علف',
    'عاوز أطلب علف',
    'عايز 5 شكاير علف بادي',
    'عايز شيكارة علف نامي',
    'عايز طن علف ناهي',
    'شيكارة بادي 23',
    'علف نامي 21',
    'علف ناهي 19',
    'علف بياض 18',
    'علف أرانب مرضعات',
    'علف مواشي تسمين',
    'علف مواشي حلاب',
    'سعر طن العلف كام',
    'شيكارة 50 كيلو',
    'ضيف شيكارة للسلة',
    'ضيف طن للسلة',
    'إيه الفرق بين البادي والنامي',
    'إيه أحسن علف للفراخ',
    'عندي كتاكيت عمر أسبوع',
    'عايز أعرف الأسعار',
  ];

  /// Start listening for voice commands
  Future<bool> startListening({
    required ValueChanged<String> onResult,
    ValueChanged<double>? onSoundLevel,
    Function(String status)? onStatus,
    Function(String errorMessage)? onError,
    Duration listenFor = const Duration(seconds: 30),
    Duration pauseFor = const Duration(seconds: 4),
    List<String>? contextualPhrases,
  }) async {
    _statusListener = onStatus;
    _errorListener = onError;

    final hasPermission = await requestMicrophonePermission();
    if (!hasPermission) {
      onError?.call('يرجى منح إذن الميكروفون أولاً');
      return false;
    }

    if (!_isInitialized || !_isAvailable) {
      final ok = await initialize(
        onStatus: onStatus,
        onError: (err) => onError?.call(mapErrorToHumanReadable(err.errorMsg)),
      );
      if (!ok) {
        onError?.call('خدمة التعرف الصوتي غير متاحة في هذا الجهاز');
        return false;
      }
    }

    if (_speechToText.isListening) {
      await stopListening();
    }

    try {
      final targetLocale = _selectedLocaleId ?? 'ar-EG';
      debugPrint('🎙️ Starting listen with locale: $targetLocale');

      final effectivePhrases = contextualPhrases != null
          ? {...defaultContextualPhrases, ...contextualPhrases}.toList()
          : defaultContextualPhrases;

      await _speechToText.listen(
        onResult: (result) {
          debugPrint('🎙️ Recognized: "${result.recognizedWords}", final: ${result.finalResult}');
          onResult(result.recognizedWords);
        },
        onSoundLevelChange: onSoundLevel,
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.search,
          partialResults: true,
          cancelOnError: false, // Don't crash on background noise
          localeId: targetLocale,
          listenFor: listenFor,
          pauseFor: pauseFor,
          contextualPhrases: effectivePhrases,
        ),
      );
      return true;
    } catch (e) {
      debugPrint('❌ Error starting speech listen: $e');
      onError?.call('تعذر تشغيل الميكروفون: $e');
      return false;
    }
  }

  /// Stop listening gracefully
  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }

  /// Cancel listening immediately
  Future<void> cancelListening() async {
    if (_speechToText.isListening) {
      await _speechToText.cancel();
    }
  }

  /// Human readable error mapping
  static String mapErrorToHumanReadable(String errorMsg) {
    final lower = errorMsg.toLowerCase();
    if (lower.contains('error_no_match') || lower.contains('nomatch') || lower.contains('no match')) {
      return 'لم نتمكن من سماعك بوضوح، يرجى التحدث قرب الميكروفون';
    }
    if (lower.contains('error_speech_timeout') || lower.contains('timeout')) {
      return 'انتهى وقت الاستماع دون سماع كلام، انقر للتحدث مجدداً';
    }
    if (lower.contains('error_network') || lower.contains('network') || lower.contains('server')) {
      return 'يرجى التحقق من اتصال الإنترنت';
    }
    if (lower.contains('error_audio') || lower.contains('recording') || lower.contains('busy')) {
      return 'الميكروفون مشغول حالياً، تأكد من إغلاق أي تطبيق صوتي آخر';
    }
    if (lower.contains('error_language_not_supported') || lower.contains('not supported')) {
      return 'محرك الصوت بهاتفك لا يدعم اللغة العربية، يرجى تفعيل التعرف الصوتي من Google';
    }
    return 'لم يتم التقاط الصوت بوضوح، حاول مرة أخرى';
  }

  /// Normalizes Arabic text for flexible matching:
  /// - Removes tashkeel
  /// - Normalizes hamzat (أ, إ, آ, ٱ -> ا)
  /// - Normalizes yaa (ى -> ي)
  /// - Normalizes taa marbuta (ة -> ه)
  static String normalizeArabic(String text) {
    if (text.isEmpty) return '';
    var result = text;
    // Remove tashkeel / diacritics
    result = result.replaceAll(RegExp(r'[\u064B-\u0652]'), '');
    // Normalize Alef
    result = result.replaceAll(RegExp(r'[أإآٱ]'), 'ا');
    // Normalize Yaa / Alef Maksura
    result = result.replaceAll('ى', 'ي');
    // Normalize Taa Marbuta
    result = result.replaceAll('ة', 'ه');
    // Normalize multiple spaces
    result = result.replaceAll(RegExp(r'\s+'), ' ').trim();
    return result;
  }

  /// Strips conversational prefixes common in Egyptian dialect to extract the product query
  static String extractCleanProductQuery(String rawText) {
    var text = rawText.trim();
    if (text.isEmpty) return '';

    final prefixes = [
      'عايز اعرف عن',
      'عاوز اعرف عن',
      'عايز اعرف',
      'عاوز اعرف',
      'ابحث لي عن',
      'ابحث عن',
      'دور لي على',
      'دور على',
      'عاوز اشوف',
      'عايز اشوف',
      'عايز اشتري',
      'عاوز اشتري',
      'عايز اجيب',
      'عاوز اجيب',
      'وريني',
      'هاتلي',
      'هات',
      'عايز',
      'عاوز',
      'محتاج',
      'لو سمحت',
      'من فضلك',
    ];

    for (final prefix in prefixes) {
      if (text.startsWith(prefix)) {
        final candidate = text.substring(prefix.length).trim();
        if (candidate.isNotEmpty) {
          text = candidate;
          break;
        }
      }
    }

    return text;
  }
}
