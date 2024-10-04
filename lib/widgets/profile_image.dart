import 'package:fluffy_mvp/models/color_model.dart';
import 'package:fluffy_mvp/models/profile_image_list.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    super.key,
    required this.indexChanged,
  });

  final Function(int) indexChanged;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  List<String> profileImageList = ProfileImageList.profileImages;
  Random random = Random();
  late int index;

  @override
  void initState() {
    super.initState();
    setState(() {
      index = random.nextInt(profileImageList.length);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.indexChanged(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(profileImageList[index]),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: InkWell(
            onTap: () {
              setState(() {
                index = (index + 1) % profileImageList.length;
              });

              widget.indexChanged(index);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.pink,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.refresh_outlined,
                color: Colors.black45,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
