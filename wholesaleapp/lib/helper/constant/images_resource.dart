import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class ImagesResource {
  /// Icons
  //static const String SPLASH = "assets/icons/splash.svg";
  static const String ARROW = "assets/icons/Arrow.svg";
  static const String CAMERA_ICON = "assets/icons/ic_camera.svg";
  static const String GALLERY_ICON = "assets/icons/ic_gallery.svg";
  static const String BABY = "assets/icons/baby.svg";
  static const String BEVERAGE = "assets/icons/beverage.svg";
  static const String FRUITS = "assets/icons/fruits.svg";
  static const String GROCERY = "assets/icons/grocery.svg";
  static const String OIL = "assets/icons/oil.svg";
  static const String VEGE = "assets/icons/vege.svg";
  static const String fb = "assets/icons/fb.svg";
  static const String insta = "assets/icons/ins.svg";
  static const String twitter = "assets/icons/t.svg";
  static const String ALERT_ICON = "assets/icons/alert_icon.svg";
  static const String LOGIN_ICON = "assets/lottie/login.json";
  static const String SPLASH = "assets/lottie/splash.json";
  static const String PROFILE_ICON = "assets/icons/profile_placeholder.svg";
  static const String EDIT_IMAGE_ICON = "assets/icons/ic_edit_image.svg";

  Future<List<Uint8List>> pickproducts() async {
    final ImagePicker _picker = ImagePicker();
    List<Uint8List> imagesData = [];

    // Pick multiple images
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      for (var image in images) {
        Uint8List imageData = await image.readAsBytes();
        imagesData.add(imageData);
      }
    }

    return imagesData;
  }

  /// Gifs
//static const String REVIEW_POSTING_GIF = "assets/gif/review_posting.gif";
}
