import 'package:fluffy_mvp/models/color_model.dart';
import 'package:flutter/material.dart';

class MoreOptionsDialog extends StatelessWidget {
  const MoreOptionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.black45,
      ),
      color: AppColors.white,
      onSelected: (int result) {
        if (result == 1) {
          print('수정하기 선택됨');
          // 여기에 수정 로직 추가
        } else if (result == 2) {
          print('삭제하기 선택됨');
          // 여기에 삭제 로직 추가
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 1,
          child: Text('수정하기'),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Text('삭제하기'),
        ),
      ],
    );
  }
}
