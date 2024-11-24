import 'package:flutter_svg/flutter_svg.dart';

import '../constant/images_resource.dart';

class SvgUtils {
  static List<SvgAssetLoader> svgAssets = [
    //const SvgAssetLoader(ImagesResource.SPLASH),
    const SvgAssetLoader(ImagesResource.ARROW),
    const SvgAssetLoader(ImagesResource.fb),
    const SvgAssetLoader(ImagesResource.insta),
    const SvgAssetLoader(ImagesResource.twitter),
    const SvgAssetLoader(ImagesResource.ALERT_ICON),
    const SvgAssetLoader(ImagesResource.LOGIN_ICON),
    const SvgAssetLoader(ImagesResource.FRUITS),
    const SvgAssetLoader(ImagesResource.VEGE),
    const SvgAssetLoader(ImagesResource.BABY),
    const SvgAssetLoader(ImagesResource.BEVERAGE),
    const SvgAssetLoader(ImagesResource.OIL),
    const SvgAssetLoader(ImagesResource.GROCERY),
    const SvgAssetLoader(ImagesResource.SPLASH),
    const SvgAssetLoader(ImagesResource.PROFILE_ICON),
    const SvgAssetLoader(ImagesResource.EDIT_IMAGE_ICON),
  ];

  static Future<void> preCacheSVGs() async {
    for (var icons in svgAssets) {
      await svg.cache.putIfAbsent(
        icons.cacheKey(null),
        () => icons.loadBytes(null),
      );
    }
  }
}
