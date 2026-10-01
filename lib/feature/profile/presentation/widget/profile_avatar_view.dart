import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/profile/logic/cubit/profile_cubit.dart';
import 'package:aleman/feature/profile/presentation/widget/profile_image_picker_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ProfileAvatarView extends StatelessWidget {
  final String? imageUrl;
  final bool isUploading;

  const ProfileAvatarView({
    super.key,
    required this.imageUrl,
    this.isUploading = false,
  });

  String _formatImageUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    final cleanPath = url.startsWith('/') ? url : '/$url';
    return '${ApiConstants.baseUrl}$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValidUrl = imageUrl != null && imageUrl!.trim().isNotEmpty;
    final cubit = context.read<ProfileCubit>();

    return GestureDetector(
      onTap: isUploading
          ? null
          : () => ProfileImagePickerBottomSheet.show(
              context,
              cubit: cubit,
              hasExistingImage: hasValidUrl,
            ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorManger.primary.withValues(alpha: 0.25),
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 46.w,
              backgroundColor: ColorManger.primaryLight.withValues(alpha: 0.12),
              child: ClipOval(
                child: SizedBox(
                  width: 92.w,
                  height: 92.w,
                  child: hasValidUrl
                      ? CachedNetworkImage(
                          imageUrl: _formatImageUrl(imageUrl!),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorManger.primary,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Iconsax.user,
                            size: 40.w,
                            color: ColorManger.primary,
                          ),
                        )
                      : Icon(
                          Iconsax.user,
                          size: 40.w,
                          color: ColorManger.primary,
                        ),
                ),
              ),
            ),
          ),

          // Uploading overlay
          if (isUploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SizedBox(
                    width: 28.w,
                    height: 28.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
            ),

          // Edit camera icon badge
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: ColorManger.primary.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Iconsax.camera, size: 14.w, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
