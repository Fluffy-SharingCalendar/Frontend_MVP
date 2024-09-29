import 'package:flutter/material.dart';
import 'package:fluffy_mvp/models/profile_image_list.dart';

class Article extends StatefulWidget {
  const Article({
    super.key,
    required this.height,
    required this.onCommentPressed,
  });

  final double height;
  final VoidCallback onCommentPressed;

  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  List<String> profileImageList = ProfileImageList.profileImages;
  int currentIndex = 0;

  void _goToNextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % profileImageList.length;
    });
  }

  void _goToPreviousImage() {
    setState(() {
      currentIndex = (currentIndex - 1 + profileImageList.length) %
          profileImageList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 작성자 정보 위젯
          AuthorInfo(profileImage: profileImageList[0]),

          // 이미지 슬라이더 위젯
          ArticleImageSlider(
            height: widget.height,
            currentIndex: currentIndex,
            profileImageList: profileImageList,
            goToNextImage: _goToNextImage,
            goToPreviousImage: _goToPreviousImage,
          ),

          // 댓글 및 좋아요 상호작용 버튼 위젯
          ArticleInteractions(
            onCommentPressed: widget.onCommentPressed,
            commentCount: 100,
            likeCount: 100,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 15.0,
            ),
            child: Text(
              "글 내용가리용용",
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 작성자 정보 위젯
class AuthorInfo extends StatelessWidget {
  final String profileImage;

  const AuthorInfo({
    Key? key,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(profileImage),
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
                  fontSize: 12.0,
                ),
              ),
              Text(
                "작성날짜",
                style: TextStyle(
                  fontSize: 10.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 이미지 슬라이더 위젯
class ArticleImageSlider extends StatelessWidget {
  final double height;
  final int currentIndex;
  final List<String> profileImageList;
  final VoidCallback goToNextImage;
  final VoidCallback goToPreviousImage;

  const ArticleImageSlider({
    Key? key,
    required this.height,
    required this.currentIndex,
    required this.profileImageList,
    required this.goToNextImage,
    required this.goToPreviousImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(profileImageList[currentIndex]),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 왼쪽 버튼
          Positioned(
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 25,
                color: Colors.black54,
              ),
              onPressed: goToPreviousImage,
            ),
          ),

          // 오른쪽 버튼
          Positioned(
            right: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 25,
                color: Colors.black54,
              ),
              onPressed: goToNextImage,
            ),
          ),

          // 이미지 인덱스 표시
          Positioned(
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.image,
                    size: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    '${currentIndex + 1} / ${profileImageList.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 댓글 및 좋아요 상호작용 버튼 위젯
class ArticleInteractions extends StatelessWidget {
  final int commentCount;
  final int likeCount;
  final VoidCallback onCommentPressed;

  const ArticleInteractions({
    Key? key,
    required this.commentCount,
    required this.likeCount,
    required this.onCommentPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Row(
        children: [
          IconButton(
            onPressed: onCommentPressed,
            icon: const Icon(
              Icons.mode_comment_rounded,
              color: Colors.black45,
            ),
          ),
          Text(
            "$commentCount",
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.black45,
            ),
          ),
          Text(
            "$likeCount",
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
