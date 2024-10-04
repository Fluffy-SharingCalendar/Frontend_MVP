import 'package:fluffy_mvp/models/color_model.dart';
import 'package:flutter/material.dart';

Future<void> alert(BuildContext context, String title, String content) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text(
              "확인",
              style: TextStyle(
                color: AppColors.brown,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
