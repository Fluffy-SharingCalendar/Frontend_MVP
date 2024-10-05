import 'package:fluffy_mvp/models/article_model.dart';
import 'package:fluffy_mvp/widgets/article_dialog.dart';
import 'package:fluffy_mvp/widgets/gradation_profile_circle.dart';
import 'package:flutter/material.dart';
import 'package:fluffy_mvp/models/profile_image_list.dart';
import 'package:provider/provider.dart';
import 'package:fluffy_mvp/providers/user_provider.dart';

class ArticleWidget extends StatefulWidget {
  const ArticleWidget({
    super.key,
    required this.height,
    required this.onCommentPressed,
    required this.article,
    required this.onArticleChanged,
  });

  final double height;
  final Function(int) onCommentPressed; // postId를 함께 전달하는 콜백
  final Article article;
  final VoidCallback onArticleChanged;

  @override
  _ArticleWidgetState createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    // 초기값으로 article에 저장된 댓글 수를 설정
    commentCount = widget.article.commentCnt;
  }

  // 댓글 수를 업데이트하는 함수
  void _updateCommentCount(int newCount) {
    setState(() {
      commentCount = newCount;
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
          AuthorInfo(
            article: widget.article,
            onArticleChanged: widget.onArticleChanged,
          ),

          // 이미지 슬라이더 위젯
          widget.article.urls.isNotEmpty
              ? ArticleWidgetImageSlider(
                  height: widget.height,
                  currentIndex: 0,
                  imageList: widget.article.urls,
                  goToNextImage: () {},
                  goToPreviousImage: () {},
                )
              : Container(),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 10.0,
            ),
            child: Text(
              widget.article.content,
              style: const TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),

          // 댓글 및 좋아요 상호작용 버튼 위젯
          ArticleWidgetInteractions(
            onCommentPressed: () =>
                widget.onCommentPressed(widget.article.postId),
            commentCount: commentCount, // 현재 댓글 수 표시
          ),

          Container(
            height: 1.0,
            decoration: const BoxDecoration(
              color: Colors.black12,
            ),
          ),
        ],
      ),
    );
  }
}

// 작성자 정보 위젯
class AuthorInfo extends StatelessWidget {
  final Article article;
  final VoidCallback onArticleChanged;

  bool isAuthor(String myNickname) {
    return article.authorNickname == myNickname;
  }

  const AuthorInfo({
    Key? key,
    required this.article,
    required this.onArticleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    List<String> profileImageList = ProfileImageList.profileImages;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GradationProfileCircle(
                authorProfileImage:
                    profileImageList[article.authorProfileImageNo],
                size: 50.0,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.authorNickname,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    article.eventDate,
                    style: const TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          isAuthor(userProvider.login!.nickname)
              ? ArticleDialog(
                  article: article,
                  onArticleChanged: onArticleChanged,
                )
              : Container(),
        ],
      ),
    );
  }
}

// 이미지 슬라이더 위젯
class ArticleWidgetImageSlider extends StatelessWidget {
  final double height;
  final int currentIndex;
  final List<String> imageList;
  final VoidCallback goToNextImage;
  final VoidCallback goToPreviousImage;

  const ArticleWidgetImageSlider({
    Key? key,
    required this.height,
    required this.currentIndex,
    required this.imageList,
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
          imageList.isNotEmpty
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        imageList[currentIndex],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(),

          // 왼쪽 버튼
          imageList.length == 1
              ? Container()
              : Positioned(
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
          imageList.length == 1
              ? Container()
              : Positioned(
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
          imageList.length == 1
              ? Container()
              : Positioned(
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
                          '${currentIndex + 1} / ${imageList.length}',
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

// 댓글 상호작용 버튼 위젯
class ArticleWidgetInteractions extends StatelessWidget {
  final int commentCount;
  final VoidCallback onCommentPressed;

  const ArticleWidgetInteractions({
    Key? key,
    required this.commentCount,
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
        ],
      ),
    );
  }
}
