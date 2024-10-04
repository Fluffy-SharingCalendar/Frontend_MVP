import 'package:fluffy_mvp/models/color_model.dart';
import 'package:fluffy_mvp/models/event_model.dart';
import 'package:fluffy_mvp/pages/post_article_page.dart';
import 'package:fluffy_mvp/providers/post_provider.dart';
import 'package:fluffy_mvp/widgets/comment.dart';
import 'package:fluffy_mvp/widgets/gradation_profile_triangle.dart';
import 'package:flutter/material.dart';
import 'package:fluffy_mvp/widgets/article_widget.dart';
import 'package:fluffy_mvp/models/profile_image_list.dart';
import 'package:provider/provider.dart';
import 'package:fluffy_mvp/providers/user_provider.dart';

class SharingMemoryPage extends StatefulWidget {
  const SharingMemoryPage({
    super.key,
    this.event,
    this.selectedDay,
  });

  final Event? event;
  final String? selectedDay;

  @override
  State<SharingMemoryPage> createState() => _SharingMemoryPageState();
}

class _SharingMemoryPageState extends State<SharingMemoryPage> {
  final ScrollController _scrollController = ScrollController(
    keepScrollOffset: true,
  );
  int page = 0;

  List<String> profileImageList = ProfileImageList.profileImages;
  bool isCommentPressed = false;

  // 댓글 창 열기/닫기
  void _toggleComments(bool isOpened) {
    setState(() {
      isCommentPressed = isOpened;
    });
  }

  void reload() {
    setState(() {
      // 새로고침 로직
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      postProvider.getInitialArticles(widget.event!.eventId);
    });
    _scrollController.jumpTo(0);
    print("새로고침 완료");
  }

  @override
  void initState() {
    super.initState();
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.getInitialArticles(widget.event!.eventId);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
          width: 100,
        ),
      ),
      // 글 작성 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostArticlePage(
                event: widget.event,
                selectedDay: widget.selectedDay,
              ),
            ),
          );
          if (shouldRefresh == true) {
            reload();
          }
        },
        backgroundColor: AppColors.brown,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 섹션
          ProfileSection(
            screenSize: screenSize,
            profileImageList: profileImageList,
            selectedDay: widget.selectedDay!,
            eventTitle: widget.event!.title,
          ),
          // 글 섹션
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!postProvider.loading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  page++;
                  postProvider.getMoreArticles(widget.event!.eventId, page);
                  return true;
                }
                return false;
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: postProvider.articles.length,
                itemBuilder: (context, index) {
                  return ArticleWidget(
                    height: screenSize.width * 0.4,
                    onCommentPressed: () => _toggleComments(true),
                    article: postProvider.articles[index],
                    onArticleChanged: reload,
                  );
                },
              ),
            ),
          ),
          // 댓글 섹션
          Container(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 20.0,
              right: 30.0,
              left: 30.0,
            ),
            width: screenSize.width * 0.3,
            height: screenSize.height,
            child: isCommentPressed
                ? CommentSection(onClosePressed: () => _toggleComments(false))
                : Container(),
          ),
        ],
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final Size screenSize;
  final List<String> profileImageList;
  final String selectedDay;
  final String eventTitle;

  const ProfileSection({
    Key? key,
    required this.screenSize,
    required this.profileImageList,
    required this.selectedDay,
    required this.eventTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        width: screenSize.width * 0.3,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradationBorderProfileTriangle(
                profileImage:
                    profileImageList[userProvider.login!.profileImageIndex],
                size: 100.0,
              ),
              const SizedBox(
                width: 15.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${userProvider.login?.nickname}님,",
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text("$selectedDay의 $eventTitle에서 있었던"),
                  const Text("추억을 기록해보세요 ☺️"),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 댓글 섹션 위젯
class CommentSection extends StatelessWidget {
  final VoidCallback onClosePressed;

  const CommentSection({
    Key? key,
    required this.onClosePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 15.0,
      ),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "댓글",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: onClosePressed,
                icon: const Icon(
                  Icons.close,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 1.0,
            decoration: const BoxDecoration(
              color: Colors.black38,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              style: const TextStyle(
                fontSize: 12.0,
              ),
              controller: textEditingController,
              decoration: const InputDecoration(
                hintText: "댓글을 입력해주세요.",
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return const Comment();
              },
            ),
          ),
        ],
      ),
    );
  }
}
