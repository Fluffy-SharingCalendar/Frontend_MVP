import 'package:fluffy_mvp/models/event_model.dart';
import 'package:fluffy_mvp/pages/post_article_page.dart';
import 'package:fluffy_mvp/providers/post_provider.dart';
import 'package:fluffy_mvp/widgets/comment.dart';
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
        title: const Text("추억 공유하기"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostArticlePage(
                      event: widget.event,
                      selectedDay: widget.selectedDay,
                    )),
          );
        },
        backgroundColor: const Color.fromARGB(255, 213, 125, 229),
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

  const ProfileSection({
    Key? key,
    required this.screenSize,
    required this.profileImageList,
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
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(profileImageList[
                        userProvider.login!.profileImageIndex]),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black45,
                    width: 1.5,
                  ),
                ),
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
          // 여기에 댓글 목록을 추가할 수 있습니다.
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
