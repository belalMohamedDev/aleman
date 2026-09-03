import 'package:aleman/feature/home/data/model/banner_model.dart';

class BannerEntity {
  final int id;
  final String title;
  final String imageUrl;
  final String link;
  final bool isActive;
  final String createdAt;

  BannerEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.link,
    required this.isActive,
    required this.createdAt,
  });
}

extension BannersModelMapper on BannersModel? {
  BannerEntity toDomain() {
    return BannerEntity(
      id: this?.id ?? 0,
      title: this?.title ?? '',
      imageUrl: this?.imageUrl ?? '',
      link: this?.link ?? '',
      isActive: this?.isActive ?? false,
      createdAt: this?.createdAt ?? '',
    );
  }
}
