import 'package:fluffy_mvp/models/color_model.dart';
import 'package:fluffy_mvp/models/comment_model.dart';
import 'package:fluffy_mvp/services/comment_service.dart';
import 'package:fluffy_mvp/widgets/alert.dart';
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
  TextEditingController _textEditingController = TextEditingController();
  bool isEditMode = false;

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
                      editMode: () {
                        setState(() {
                          isEditMode = true;
                          _textEditingController = TextEditingController(
                            text: widget.comment.content,
                          );
                        });
                      },
                    )
                  : Container(),
            ],
          ),
          // 댓글 영역
          const SizedBox(
            height: 10.0,
          ),
          isEditMode
              ? Column(
                  children: [
                    TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            bool isSuccess = await CommentService.modifyComment(
                                widget.comment.commentId,
                                _textEditingController.text);

                            if (_textEditingController.text.isNotEmpty) {
                              if (isSuccess) {
                                await alert(context, "댓글 수정", "댓글을 수정하였습니다.");
                                widget.onCommentChanged();
                                setState(() {
                                  isEditMode = false;
                                });
                              }
                            } else {
                              await alert(context, "수정 실패", "댓글을 입력해주세요.");
                            }
                          },
                          child: const Text(
                            "수정 완료👍",
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.brown,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              : Text(
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
