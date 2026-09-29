import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:aleman/core/statsScreen/global_error.dart';
import 'package:aleman/feature/address/presentation/screen/user_addresses_screen.dart';
import 'package:aleman/feature/order/presentation/screen/my_orders_screen.dart';
import 'package:aleman/feature/order/presentation/screen/small_merchants_orders_screen.dart';
import 'package:aleman/feature/profile/logic/cubit/profile_cubit.dart';
import 'package:aleman/feature/profile/logic/cubit/profile_state.dart';
import 'package:aleman/feature/profile/presentation/screen/my_small_merchants_screen.dart';
import 'package:aleman/feature/profile/presentation/widget/logout_confirmation_bottom_sheet.dart';
import 'package:aleman/feature/profile/presentation/widget/profile_header_card.dart';
import 'package:aleman/feature/profile/presentation/widget/profile_menu_group.dart';
import 'package:aleman/feature/profile/presentation/widget/profile_menu_item.dart';
import 'package:aleman/feature/profile/presentation/widget/profile_shimmer.dart';
import 'package:aleman/feature/vehicle/presentation/screen/user_vehicles_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<ProfileCubit>()..fetchUserProfile(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            'حسابي',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            state.maybeWhen(
              success: (profile, isUploadingImage, uploadError, uploadSuccess) {
                if (uploadError != null && uploadError.isNotEmpty) {
                  AppToast.showError(context, message: uploadError);
                } else if (uploadSuccess != null && uploadSuccess.isNotEmpty) {
                  AppToast.showSuccess(context, message: uploadSuccess);
                }
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.when(
              initial: () => const ProfileShimmer(),
              loading: () => const ProfileShimmer(),
              error: (error) => GlobalError(
                onTap: () {
                  context.read<ProfileCubit>().fetchUserProfile();
                },
              ),
              success: (profile, isUploadingImage, uploadError, uploadSuccess) {
                final bool isMainCustomer =
                    profile.role == 'ParentMerchantId' ||
                    profile.role == 'ParentMerchant' ||
                    profile.role.toLowerCase().contains('parentmerchant') ||
                    profile.role.toLowerCase().contains('bigmerchant');

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    children: [
                      ProfileHeaderCard(
                        name: profile.name,
                        role: isMainCustomer ? 'وكيل معتمد' : 'عميل',
                        phoneNumber: profile.phoneNumber,
                        imageUrl: profile.profileImageUrl,
                        isUploading: isUploadingImage,
                      ),
                      SizedBox(height: 24.h),

                      ProfileMenuGroup(
                        title: 'إعدادات الحساب',
                        items: [
                          ProfileMenuItem(
                            icon: Iconsax.location,
                            title: 'العناوين',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const UserAddressesScreen(),
                                ),
                              );
                            },
                          ),
                          ProfileMenuItem(
                            icon: Iconsax.truck_fast,
                            title: 'سيارات التحميل والسائقين',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const UserVehiclesScreen(),
                                ),
                              );
                            },
                          ),
                          ProfileMenuItem(
                            icon: Iconsax.lock,
                            title: 'تغيير كلمة المرور',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.changePasswordRoute,
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      ProfileMenuGroup(
                        title: 'الطلبات',
                        items: [
                          ProfileMenuItem(
                            icon: Iconsax.box,
                            title: 'طلباتي',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MyOrdersScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      if (isMainCustomer) ...[
                        ProfileMenuGroup(
                          title: 'إدارة العملاء',
                          items: [
                            ProfileMenuItem(
                              icon: Iconsax.people,
                              title: 'عملائي',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MySmallMerchantsScreen(
                                      merchants: profile.smallMerchants ?? [],
                                    ),
                                  ),
                                );
                              },
                            ),
                            ProfileMenuItem(
                              icon: Iconsax.task_square,
                              title: 'أوردرات العملاء',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const SmallMerchantsOrdersScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                      ],

                      ProfileMenuGroup(
                        items: [
                          ProfileMenuItem(
                            icon: Iconsax.logout,
                            title: 'تسجيل الخروج',
                            textColor: Colors.red,
                            iconColor: Colors.red,
                            showTrailing: false,
                            onTap: () =>
                                LogoutConfirmationBottomSheet.show(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
