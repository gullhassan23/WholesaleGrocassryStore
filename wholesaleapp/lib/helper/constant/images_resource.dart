import 'dart:math';
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
  static const String Meat = "assets/icons/meat.svg";
  static const String frozen = "assets/icons/fr.svg";
  static const String nuts = "assets/icons/nuts.svg";
  static const String cl = "assets/icons/cl.svg";
  static const String VEGE = "assets/icons/vege.svg";
  static const String fb = "assets/icons/fb.svg";
  static const String insta = "assets/icons/ins.svg";
  static const String twitter = "assets/icons/t.svg";
  static const String empty_cart = "assets/lottie/empty_cart.json";
  static const String ALERT_ICON = "assets/icons/alert_icon.svg";
  static const String LOGIN_ICON = "assets/lottie/login.json";
  static const String DASH = "assets/lottie/dash.json";
  static const String SPLASH = "assets/lottie/splash.json";
  static const String PROFILE_ICON = "assets/icons/profile_placeholder.svg";
  static const String EDIT_IMAGE_ICON = "assets/icons/ic_edit_image.svg";

  String getUid() {
    return (100000 + Random().nextInt(10000)).toString();
  }

  pickImage(ImageSource source) async {
    ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (_file != null) {
      return await _file.readAsBytes();
    }
    print("No Image is selected");
  }

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
}
