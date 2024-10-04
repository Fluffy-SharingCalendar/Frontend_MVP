import 'package:fluffy_mvp/models/color_model.dart';
import 'package:flutter/material.dart';
import 'package:fluffy_mvp/models/profile_image_list.dart';

class GradationProfileCircle extends StatefulWidget {
  const GradationProfileCircle({
    super.key,
    required this.authorProfileImage,
    required this.size,
  });

  final String authorProfileImage;
  final double size;

  @override
  _GradationProfileCircleState createState() => _GradationProfileCircleState();
}

class _GradationProfileCircleState extends State<GradationProfileCircle> {
  List<String> profileImageList = ProfileImageList.profileImages;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.pink,
            AppColors.green,
            AppColors.blue,
            AppColors.purple,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0), // 그라데이션 효과를 위한 패딩
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.authorProfileImage),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
