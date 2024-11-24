import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../helper/constant/colors_resource.dart';
import '../../helper/constant/images_resource.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorsResource.PROFILE_AND_COVER_PIC_BG_COLOR,
                    border: Border.all(
                      color: ColorsResource.WHITE,
                      width: 4,
                    ),
                  ),
                  child: ClipOval(
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsResource.PROFILE_AND_COVER_PIC_BG_COLOR,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            20,
                          ),
                        ),
                      ),
                      child: SvgPicture.asset(
                        ImagesResource.PROFILE_ICON,
                        fit: BoxFit.none,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 80,
                  top: 80,
                  child: GestureDetector(
                    child: SvgPicture.asset(
                      ImagesResource.EDIT_IMAGE_ICON,
                      height: 24,
                      width: 24,
                    ),
                    onTap: () {
                      // _pickProfileImage();
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ProfileListItem(text: 'Sheikh Faizan'),
          ProfileListItem(text: 'Fazanmuzamal89@gmail.com'),
          ProfileListItem(text: '03244985570'),
          SizedBox(
            height: 50,
          ),
          InkWell(
            child: ProfileListItem(text: 'Logout'),
          ),
        ],
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    required this.text,
    this.hasNavigation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blueGrey.shade100,
          ),
          child: Row(
            children: <Widget>[
              Text(
                this.text,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              if (this.hasNavigation)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.blueGrey,
                )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
