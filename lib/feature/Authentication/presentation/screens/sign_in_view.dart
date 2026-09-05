import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/email_login_text_form_field.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/password_login_text_form_field.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/sign_in_button.dart';
import 'package:aleman/feature/Authentication/presentation/sharedWidgetBetweenScreen/headline_text_auth_screen.dart';
import 'package:aleman/feature/Authentication/presentation/sharedWidgetBetweenScreen/animated_call_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  void _showContactOptions(BuildContext context) {
    const String phoneNumber = "+201069225923";
    showModalBottomSheet(
      backgroundColor: ColorManger.white,
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
              // Text(
              //   "تواصل معنا",
              //   style: Theme.of(context).textTheme.titleLarge
              //       ?.copyWith(fontWeight: FontWeight.bold),
              // ),
              Container(
                width: 45,
                height: 2.5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: ColorManger.black26,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              ListTile(
                leading: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.14159),
                  child: const Icon(
                    Iconsax.call_received5,
                    color: Colors.green,
                  ),
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
                leading: Image.asset(
                  ImageAsset.whatsapp,
                  width: 24,
                  height: 24,
                ),
                // leading: const Icon(Iconsax.message, color: Colors.teal),
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
                          AppToast.showSuccess(
                            context,
                            message: "تم نسخ رقم التواصل بنجاح 🌾",
                          );
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

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: SizedBox(
        height: responsive.setHeight(8),
        // child: const HaveAnAccountText(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: responsive.setPadding(
            left: 5.5,
            right: 5,
            top: 5,
            bottom: 4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadlineTextAuthScreen(
                titleText: AppStrings.welcomeBack,
                subTitleText: AppStrings.toGetStartedSignInToYourAccount,
              ),

              SizedBox(height: responsive.setHeight(6)),

              const EmailLoginTextFormField(),
              SizedBox(height: responsive.setHeight(2)),

              const PasswordLoginTextFormField(),
              SizedBox(height: responsive.setHeight(3)),

              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.forgetPasswordRoute);
                  },
                  child: Text(
                    context.translate(AppStrings.forgetPassword),
                    style: Theme.of(context).textTheme.titleMedium!
                        .copyWith(fontSize: responsive.setTextSize(3.5)),
                  ),
                ),
              ),
              SizedBox(height: responsive.setHeight(3.5)),

              const SignInButton(),
              SizedBox(height: responsive.setHeight(5)),

              // const OrSignWithText(),
              // SizedBox(height: responsive.setHeight(3)),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartDocked,
      floatingActionButton: AnimatedCallButton(
        onPressed: () => _showContactOptions(context),
      ),
    );
  }
}
