import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

void showAuthContactOptions(BuildContext context) {
  const String phoneNumber = "201110767100";
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 3,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            ListTile(
              leading: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.14159),
                child: const Icon(Iconsax.call_received5, color: Colors.green),
              ),
              title: const Text("اتصال مباشر"),
              onTap: () async {
                Navigator.pop(context);
                final Uri url = Uri(scheme: 'tel', path: phoneNumber);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
            ListTile(
              leading: Image.asset(ImageAsset.whatsapp, width: 24, height: 24),
              title: const Text("واتساب"),
              onTap: () async {
                Navigator.pop(context);
                final Uri url = Uri.parse("https://wa.me/$phoneNumber");
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.copy, color: ColorManger.goldDark),
              title: const Text("نسخ الرقم"),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(const ClipboardData(text: phoneNumber))
                    .then((_) {
                      if (context.mounted) {
                        // AppToast.showSuccess(
                        //   context,
                        //   message: "تم نسخ رقم التواصل بنجاح 🌾",
                        // );
                      }
                    });
              },
            ),
          ],
        ),
      );
    },
  );
}

class AuthContactSupportLink extends StatelessWidget {
  const AuthContactSupportLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => showAuthContactOptions(context),
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconsax.headphone,
                size: 16.sp,
                color: const Color(0xFF64748B),
              ),
              SizedBox(width: 6.w),
              Text(
                'تحتاج مساعدة؟ تواصل مع خدمة العملاء',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
