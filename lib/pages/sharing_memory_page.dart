import 'package:fluffy_mvp/models/color_model.dart';
import 'package:fluffy_mvp/models/event_model.dart';
import 'package:fluffy_mvp/pages/post_article_page.dart';
import 'package:fluffy_mvp/providers/comment_provider.dart';
import 'package:fluffy_mvp/providers/post_provider.dart';
import 'package:fluffy_mvp/services/comment_service.dart';
import 'package:fluffy_mvp/widgets/alert.dart';
import 'package:fluffy_mvp/widgets/comment_widget.dart';
import 'package:fluffy_mvp/widgets/gradation_profile_triangle.dart';
import 'package:flutter/material.dart';
import 'package:fluffy_mvp/widgets/article_widget.dart';
import 'package:fluffy_mvp/models/profile_image_list.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:fluffy_mvp/providers/user_provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  // 기존 ScrollController 대신 AutoScrollController 사용
  final AutoScrollController _scrollController = AutoScrollController(
    keepScrollOffset: true,
  );
  int page = 0;
  int? selectedPostId;
  bool isCommentPressed = false;
  bool isLoading = false;

  void _toggleComments(bool isOpened, [int? postId]) {
    setState(() {
      isCommentPressed = isOpened;
      selectedPostId = postId;
    });
  }

  void scrollToItem(int index) async {
    await _scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: const Duration(milliseconds: 1),
    );
    _scrollController.highlight(index);

    setState(() {
      isLoading = false;
    });
  }

  void reload() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.update(widget.event!.eventId);
    _scrollController.jumpTo(0);

    setState(() {
      page = 0;
    });
  }

  void uploadCommentCnt() async {
    final double currentScrollPosition = _scrollController.position.pixels;
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.update(widget.event!.eventId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(currentScrollPosition);
    });

    setState(() {
      page = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.getInitialArticles(widget.event!.eventId);
    setState(() {
      isLoading = false;
    });
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
    Timer? debounce;

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
            setState(() {
              isLoading = true;
            });
            await postProvider.updateAfterPosting(widget.event!.eventId);
            if (postProvider.newArticleIndex != -1) {
              scrollToItem(postProvider.newArticleIndex);
            }
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
            profileImageList: ProfileImageList.profileImages,
            selectedDay: widget.selectedDay!,
            eventTitle: widget.event!.title,
          ),
          // 글 섹션
          Expanded(
            child: Stack(
              children: [
                Opacity(
                  opacity: isLoading ? 0.0 : 1.0,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        if (debounce?.isActive ?? false) return false;
                        if (!postProvider.loading) {
                          debounce = Timer(const Duration(milliseconds: 500),
                              () async {
                            postProvider.setLoading(true);
                            page++;
                            try {
                              await postProvider.getMoreArticles(
                                  widget.event!.eventId, page);
                            } catch (error) {
                              print("Error: $error");
                            } finally {
                              postProvider.setLoading(false);
                            }
                          });
                        }
                        return true;
                      }
                      return false;
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: postProvider.articles.length,
                      itemBuilder: (context, index) {
                        return AutoScrollTag(
                          key: ValueKey(index),
                          controller: _scrollController,
                          index: index,
                          child: ArticleWidget(
                            height: screenSize.width * 0.4,
                            onCommentPressed: (postId) =>
                                _toggleComments(true, postId),
                            article: postProvider.articles[index],
                            onArticleChanged: reload,
                            index: index,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.brown),
                      backgroundColor: AppColors.pink,
                    ),
                  ),
              ],
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
                ? CommentSection(
                    onClosePressed: () => _toggleComments(false),
                    postId: selectedPostId!, // 선택된 postId 전달
                    onChangedCommentCnt: uploadCommentCnt,
                  )
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

// 댓글 섹션
class CommentSection extends StatefulWidget {
  final VoidCallback onClosePressed;
  final int postId;
  final VoidCallback onChangedCommentCnt;

  const CommentSection({
    Key? key,
    required this.onClosePressed,
    required this.postId,
    required this.onChangedCommentCnt,
  }) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant CommentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.postId != widget.postId) {
      _fetchComments();
      _scrollController.jumpTo(0);
    }
  }

  void _fetchComments() async {
    final commentProvider =
        Provider.of<CommentProvider>(context, listen: false);
    await commentProvider.getComments(widget.postId);
  }

  @override
  void initState() {
    super.initState();
    final commentProvider =
        Provider.of<CommentProvider>(context, listen: false);
    commentProvider.getComments(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentProvider>(context);
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
                onPressed: widget.onClosePressed,
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
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      hintText: "댓글을 입력해주세요.",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (_textEditingController.text.isNotEmpty) {
                    bool isSuccess = await CommentService.postComment(
                        widget.postId, _textEditingController.text);

                    if (isSuccess) {
                      widget.onChangedCommentCnt();
                      _fetchComments();
                      _textEditingController.clear();

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent);

                          Future.delayed(const Duration(milliseconds: 100), () {
                            if (_scrollController.hasClients) {
                              _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent);
                            }
                          });
                        }
                      });
                    }
                  } else {
                    alert(context, "작성 실패", "댓글을 입력해주세요.");
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: commentProvider.comments.length,
              itemBuilder: (context, index) {
                return CommentWidget(
                  comment: commentProvider.comments[index],
                  onCommentChanged: _fetchComments,
                  onChangedCommentCnt: widget.onChangedCommentCnt,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
