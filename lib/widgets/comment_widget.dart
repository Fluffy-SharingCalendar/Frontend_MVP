import 'package:fluffy_mvp/models/comment_model.dart';
import 'package:fluffy_mvp/widgets/comment_dialog.dart';
import 'package:fluffy_mvp/widgets/gradation_profile_circle.dart';
import 'package:flutter/material.dart';
import 'package:fluffy_mvp/models/profile_image_list.dart';
import 'package:provider/provider.dart';
import 'package:fluffy_mvp/providers/user_provider.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    required this.comment,
    required this.onCommentChanged,
    required this.onChangedCommentCnt,
  });

  final Comment comment;
  final VoidCallback onCommentChanged;
  final VoidCallback onChangedCommentCnt;

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  List<String> profileImageList = ProfileImageList.profileImages;

  bool isAuthor(String myNickname) {
    return widget.comment.authorNickname == myNickname;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 댓글 작성자 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GradationProfileCircle(
                    authorProfileImage:
                        profileImageList[widget.comment.authorProfileNo],
                    size: 35,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment.authorNickname,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        widget.comment.createdAt,
                        style: const TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isAuthor(userProvider.login!.nickname)
                  ? CommentDialog(
                      comment: widget.comment,
                      onCommentChanged: widget.onCommentChanged,
                      onChangedCommentCnt: widget.onChangedCommentCnt,
                    )
                  : Container(),
            ],
          ),
          // 댓글 영역
          const SizedBox(
            height: 10.0,
          ),
          Text(
            widget.comment.content,
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
