import 'package:fluffy_mvp/models/color_model.dart';
import 'package:flutter/material.dart';

class GradationBorderProfileTriangle
 extends StatelessWidget {
  const GradationBorderProfileTriangle
  ({
    super.key,
    required this.profileImage,
    required this.size,
  });

  final String profileImage;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.pink, 
            AppColors.green, 
            AppColors.blue, 
            AppColors.purple, 
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0), 
        child: Container(
          width: size - 6, 
          height: size - 6,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(profileImage),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
