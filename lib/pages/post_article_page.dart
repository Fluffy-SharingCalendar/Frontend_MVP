import 'package:fluffy_mvp/models/posting_model.dart';
import 'package:fluffy_mvp/models/event_model.dart';
import 'package:fluffy_mvp/pages/sharing_memory_page.dart';
import 'package:fluffy_mvp/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class PostArticlePage extends StatefulWidget {
  const PostArticlePage({
    super.key,
    this.event,
    this.selectedDay,
  });

  final Event? event;
  final String? selectedDay;

  @override
  State<PostArticlePage> createState() => _PostArticlePageState();
}

class _PostArticlePageState extends State<PostArticlePage> {
  List<PlatformFile?> _selectedFiles = []; // FilePicker의 PlatformFile 사용
  final TextEditingController _textController = TextEditingController();

  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withReadStream: false, // bytes 사용을 위해 withReadStream을 false로 설정
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.files;
      });
    }
  }

  bool isValid() {
    return _textController.text.isNotEmpty && _selectedFiles.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("글 작성"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          width: screenSize.width * 0.4,
          height: screenSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ImagePickerButton(onPickImages: _pickImages),
              const SizedBox(height: 20),
              ImageList(selectedFiles: _selectedFiles),
              const SizedBox(height: 20),
              Expanded(
                child: TextField(
                  controller: _textController,
                  expands: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "글을 작성하세요.",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SubmitButton(onSubmit: () {
                    if (!isValid()) return;

                    Posting posting = Posting(
                      eventId: widget.event!.eventId,
                      eventDate: widget.selectedDay ?? "Null",
                      content: _textController.text,
                      files: _selectedFiles
                          .where((file) => file?.bytes != null) // bytes로 체크
                          .map((file) =>
                              base64Encode(file!.bytes!)) // base64 인코딩
                          .toList(),
                    );

                    PostService.postArticle(posting);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SharingMemoryPage(),
                      ),
                    );
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImagePickerButton extends StatelessWidget {
  final VoidCallback onPickImages;

  const ImagePickerButton({required this.onPickImages, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: onPickImages,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image_search_outlined,
                color: Colors.black54,
              ),
              SizedBox(width: 10.0),
              Text(
                "이미지 불러오기",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ImageList extends StatelessWidget {
  final List<PlatformFile?> selectedFiles;

  const ImageList({required this.selectedFiles, super.key});

  @override
  Widget build(BuildContext context) {
    return selectedFiles.isEmpty
        ? Container()
        : SizedBox(
            height: 150.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedFiles.length,
              itemBuilder: (context, index) {
                final file = selectedFiles[index];
                if (file != null && file.bytes != null) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(file.bytes!), // 파일 미리보기
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Text('이미지 로딩 에러');
                }
              },
            ),
          );
  }
}

class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitButton({required this.onSubmit, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSubmit,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add,
            color: Colors.black54,
          ),
          SizedBox(width: 10.0),
          Text(
            "작성 완료",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
