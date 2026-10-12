import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/widget/product_search_delegate.dart';
import 'package:aleman/feature/voice_assistant/logic/cubit/voice_assistant_cubit.dart';
import 'package:aleman/feature/voice_assistant/logic/cubit/voice_assistant_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class AiVoiceAssistantSheet extends StatefulWidget {
  const AiVoiceAssistantSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) => BlocProvider(
        create: (_) => instance<VoiceAssistantCubit>(),
        child: const AiVoiceAssistantSheet(),
      ),
    );
  }

  @override
  State<AiVoiceAssistantSheet> createState() => _AiVoiceAssistantSheetState();
}

class _AiVoiceAssistantSheetState extends State<AiVoiceAssistantSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Greet user with male voice upon opening, then auto-listen
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<VoiceAssistantCubit>().greetUserAndListen();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _handleAction(BuildContext context, String action, dynamic data) {
    HapticFeedback.mediumImpact();
    final navigator = Navigator.of(context);

    switch (action) {
      case 'refresh_cart':
        // Refresh cart count and open cart
        try {
          context.read<CartCubit>().getCartCount();
        } catch (_) {}
        navigator.pop();
        Navigator.of(context).pushNamed(Routes.cartRoute);
        break;

      case 'navigate_checkout':
      case 'order_created':
        try {
          context.read<CartCubit>().getCartCount();
        } catch (_) {}
        navigator.pop();
        Navigator.of(context).pushNamed(Routes.cartRoute);
        break;

      case 'navigate_search':
        navigator.pop();
        final cubit = context.read<HomeCuibtCubit>();
        final cartCubit = context.read<CartCubit>();
        final query = data is String ? data : '';
        showSearch(
          context: context,
          delegate: ProductSearchDelegate(
            products: cubit.state.products,
            cartCubit: cartCubit,
            homeCubit: cubit,
          ),
          query: query,
        );
        break;

      case 'confirm_order':
        context.read<VoiceAssistantCubit>().processCommand('أكد الأوردر');
        break;

      case 'order_cancelled':
        try {
          context.read<CartCubit>().getCartCount();
        } catch (_) {}
        break;

      case 'require_login':
        navigator.pop();
        Navigator.of(context, rootNavigator: true).pushNamed(Routes.loginRoute);
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceAssistantCubit, VoiceAssistantState>(
      listener: (context, state) {
        if (state.status == VoiceAssistantStatus.success &&
            state.response != null) {
          final action = state.response!.action;
          if (action == 'refresh_cart') {
            try {
              context.read<CartCubit>().getCartCount();
            } catch (_) {}
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<VoiceAssistantCubit>();

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 28,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: 14.h,
            left: 20.w,
            right: 20.w,
            bottom: MediaQuery.of(context).viewInsets.bottom + 26.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top drag indicator
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 14.h),

              // Header with Title & Speaker icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorManger.primary.withValues(alpha: 0.08),
                              ColorManger.buttonColor.withValues(alpha: 0.12),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.cpu_setting,
                              size: 17.sp,
                              color: ColorManger.primary,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'مساعد الإيمان الذكي (AI)',
                              style: getBoldStyle(
                                fontSize: 13.5.sp,
                                color: ColorManger.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (state.isSpeaking)
                        IconButton(
                          onPressed: cubit.stopSpeaking,
                          icon: Icon(
                            Icons.volume_up_rounded,
                            color: ColorManger.primaryLight,
                            size: 22.sp,
                          ),
                          tooltip: 'إيقاف الصوت',
                        ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          size: 22.sp,
                          color: Colors.grey.shade600,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Center Visual Element
              if (state.status == VoiceAssistantStatus.processing) ...[
                // Loading / Thinking animation
                Container(
                  width: 80.w,
                  height: 80.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorManger.primary.withValues(alpha: 0.06),
                  ),
                  child: SizedBox(
                    width: 38.w,
                    height: 38.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.w,
                      valueColor: const AlwaysStoppedAnimation(
                        ColorManger.buttonColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'جاري التفكير ومعالجة طلبك عبر الذكاء الاصطناعي...',
                  style: getSemiBoldStyle(
                    fontSize: 13.sp,
                    color: ColorManger.primary,
                  ),
                ),
              ] else if (state.status == VoiceAssistantStatus.listening) ...[
                // Mic with pulsing rings
                GestureDetector(
                  onTap: cubit.stopListening,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, _) {
                          return Container(
                            width: 110.w * _pulseAnimation.value,
                            height: 110.h * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorManger.buttonColor.withValues(
                                alpha:
                                    0.12 * (1.2 - _pulseAnimation.value + 0.8),
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        width: 76.w,
                        height: 76.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              ColorManger.buttonColor,
                              ColorManger.agriculturalGreen,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ColorManger.buttonColor.withValues(
                                alpha: 0.35,
                              ),
                              blurRadius: 16,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.mic_rounded,
                          size: 34.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'تحدث بأمرك أو طلبك الآن... (أعلاف، إضافة للسلة، إنشاء طلب)',
                  textAlign: TextAlign.center,
                  style: getSemiBoldStyle(
                    fontSize: 12.5.sp,
                    color: ColorManger.primaryLight,
                  ),
                ),
              ] else ...[
                // Idle / Success Mic icon
                GestureDetector(
                  onTap: cubit.startListening,
                  child: Container(
                    width: 68.w,
                    height: 68.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [ColorManger.primaryLight, ColorManger.primary],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManger.primary.withValues(alpha: 0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.mic_none_rounded,
                      size: 30.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'انقر على الميكروفون للتحدث بأمر جديد',
                  style: getSemiBoldStyle(
                    fontSize: 12.sp,
                    color: ColorManger.authSubtitleGrey,
                  ),
                ),
              ],

              SizedBox(height: 14.h),

              // Recognized Query or Response Box
              if (state.recognizedText.isNotEmpty ||
                  state.response != null) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: state.response != null
                          ? ColorManger.primary.withValues(alpha: 0.03)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.recognizedText.isNotEmpty) ...[
                        Row(
                          children: [
                            // Icon(
                            //   Iconsax.user,
                            //   size: 14.sp,
                            //   color: ColorManger.authSubtitleGrey,
                            // ),
                            // SizedBox(width: 6.w),
                            Text(
                              'أنت: ',
                              style: getBoldStyle(
                                fontSize: 11.5.sp,
                                color: ColorManger.authSubtitleGrey,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                state.recognizedText,
                                style: getSemiBoldStyle(
                                  fontSize: 12.5.sp,
                                  color: ColorManger.authTitleDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (state.response != null)
                          Divider(height: 16.h, color: Colors.grey.shade200),
                      ],
                      if (state.response != null) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                state.response!.spokenReply,
                                style: getBoldStyle(
                                  fontSize: 13.sp,
                                  color: ColorManger.primary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
              ],

              // Action button if response has action
              if (state.response != null &&
                  state.response!.action != 'none') ...[
                if (state.response!.action == 'confirm_order') ...[
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: () => _handleAction(
                            context,
                            'confirm_order',
                            state.response!.data,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManger.primaryLight,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'تأكيد وتسجيل الطلب',
                            style: getBoldStyle(
                              fontSize: 13.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        flex: 2,
                        child: OutlinedButton(
                          onPressed: () => _handleAction(
                            context,
                            'refresh_cart',
                            state.response!.data,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ColorManger.primary,
                            side: const BorderSide(color: ColorManger.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'تعديل السلة',
                            style: getBoldStyle(
                              fontSize: 12.5.sp,
                              color: ColorManger.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _handleAction(
                        context,
                        state.response!.action,
                        state.response!.data,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManger.primaryLight.withValues(
                          alpha: 0.4,
                        ),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        _getActionLabel(state.response!.action),
                        style: getBoldStyle(
                          fontSize: 13.5.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 10.h),
              ],

              SizedBox(height: 12.h),
              // Message Input Bar (Matching Login TextFormField styling)
              TextFormField(
                controller: _textController,
                style: getSemiBoldStyle(
                  fontSize: 13.5.sp,
                  color: ColorManger.authTitleDark,
                ),
                decoration: InputDecoration(
                  hintText: 'اكتب استفسارك أو طلبك هنا...',
                  hintStyle: getMediumStyle(
                    fontSize: 12.5.sp,
                    color: ColorManger.authHintGrey,
                  ),
                  filled: true,
                  fillColor: ColorManger.authFieldBg,
                  prefixIcon: Icon(
                    Iconsax.message_text,
                    color: ColorManger.authIconColor,
                    size: 20.sp,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_textController.text.trim().isNotEmpty) {
                        cubit.processCommand(_textController.text.trim());
                        _textController.clear();
                      }
                    },
                    icon: Icon(
                      Iconsax.send_1,
                      size: 20.sp,
                      color: ColorManger.primaryLight,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(
                      color: ColorManger.authFieldBorder,
                      width: 1.2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(
                      color: ColorManger.authFieldBorder,
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(
                      color: ColorManger.primaryLight,
                      width: 1.5,
                    ),
                  ),
                ),
                onFieldSubmitted: (text) {
                  if (text.trim().isNotEmpty) {
                    cubit.processCommand(text.trim());
                    _textController.clear();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getActionLabel(String action) {
    switch (action) {
      case 'refresh_cart':
        return 'عرض سلة المشتريات';
      case 'navigate_checkout':
        return 'متابعة إتمام الطلب';
      case 'order_created':
        return 'متابعة وتأكيد الطلب';
      case 'navigate_search':
        return 'عرض نتائج المنتجات';
      case 'confirm_order':
        return 'تأكيد وتسجيل الطلب';
      case 'order_cancelled':
        return 'عرض السلة';
      case 'require_login':
        return 'تسجيل الدخول للمتابعة';
      default:
        return 'تنفيذ الإجراء';
    }
  }
}
