import 'package:flutter_riverpod/legacy.dart';

import '../models/banner_model.dart';

final bannerProvider = StateNotifierProvider<BannerProvider, List<BannerModel>>(
  (ref) => BannerProvider(),
);

class BannerProvider extends StateNotifier<List<BannerModel>> {
  BannerProvider() : super([]);

  void setBanners(List<BannerModel> banners) => state = banners;
}
