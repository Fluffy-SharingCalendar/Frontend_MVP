import 'package:fluffy_mvp/models/article_model.dart';
import 'package:fluffy_mvp/models/color_model.dart';
import 'package:fluffy_mvp/pages/modify_article_page.dart';
import 'package:fluffy_mvp/services/post_service.dart';
import 'package:fluffy_mvp/widgets/alert.dart';
import 'package:flutter/material.dart';

class MoreOptionsDialog extends StatelessWidget {
  const MoreOptionsDialog({
    super.key,
    required this.article,
    required this.onArticleChanged,
  });

  final Article article;
  final VoidCallback onArticleChanged;

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
          bool? shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModifyArticlePage(
                article: article,
              ),
            ),
          );

          if (shouldRefresh == true) {
            onArticleChanged(); // 수정 후 새로고침 콜백 호출
          }
          // 여기에 수정 로직 추가
        } else if (result == 2) {
          bool isSuccess = await PostService.deleteArticle(article.postId);
          if (isSuccess) {
            await alert(context, "삭제", "게시글 삭제에 성공하였습니다.");
            onArticleChanged();
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
