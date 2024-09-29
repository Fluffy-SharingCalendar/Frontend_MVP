import 'package:flutter/material.dart';
import 'package:fluffy_mvp/models/profile_image_list.dart';

class Comment extends StatefulWidget {
  const Comment({
    super.key,
  });

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  List<String> profileImageList = ProfileImageList.profileImages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 댓글 작성자 정보
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(profileImageList[1]),
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
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.black45,
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "작성자 닉네임",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10.0,
                    ),
                  ),
                  Text(
                    "작성날짜",
                    style: TextStyle(
                      fontSize: 8.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 댓글 영역
          const SizedBox(
            height: 5.0,
          ),
          const Text(
            "댓글 내용",
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
