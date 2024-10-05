import 'package:fluffy_mvp/models/comment_model.dart';
import 'package:fluffy_mvp/models/color_model.dart';
import 'package:fluffy_mvp/services/comment_service.dart';
import 'package:fluffy_mvp/widgets/alert.dart';
import 'package:flutter/material.dart';

class CommentDialog extends StatelessWidget {
  const CommentDialog({
    super.key,
    required this.comment,
    required this.onCommentChanged,
    required this.onChangedCommentCnt,
    required this.editMode,
  });

  final Comment comment;
  final VoidCallback onCommentChanged;
  final VoidCallback onChangedCommentCnt;
  final VoidCallback editMode;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.black45,
      ),
      color: AppColors.white,
      onSelected: (int result) async {
        if (result == 1) {
          editMode();
        } else if (result == 2) {
          bool isSuccess =
              await CommentService.deleteComment(comment.commentId);
          print("댓글 삭제 성공 : $isSuccess");
          if (isSuccess) {
            await alert(context, "삭제", "게시글 삭제에 성공하였습니다.");
            onCommentChanged();
            onChangedCommentCnt();
          }
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
