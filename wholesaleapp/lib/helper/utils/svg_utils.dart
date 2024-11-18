import 'package:flutter_svg/flutter_svg.dart';

import '../constant/images_resource.dart';

class SvgUtils {
  static List<SvgAssetLoader> svgAssets = [
    const SvgAssetLoader(ImagesResource.SPLASH),
    const SvgAssetLoader(ImagesResource.ARROW),
    const SvgAssetLoader(ImagesResource.fb),
    const SvgAssetLoader(ImagesResource.insta),
    const SvgAssetLoader(ImagesResource.twitter),
    const SvgAssetLoader(ImagesResource.ALERT_ICON),
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
