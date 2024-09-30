import 'package:fluffy_mvp/models/posting_model.dart';
import 'package:fluffy_mvp/pages/sharing_memory_page.dart';
import 'package:fluffy_mvp/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluffy_mvp/models/event_model.dart';
import 'dart:typed_data';
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
  List<Uint8List?> _imageBytesList = [];
  final TextEditingController _textController = TextEditingController();

  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _imageBytesList = result.files.map((file) => file.bytes).toList();
      });
    }
  }

  bool isValid() {
    return _textController.text.isNotEmpty;
  }

  List<String> _convertToBase64(List<Uint8List?> imageBytesList) {
    return imageBytesList
        .where((bytes) => bytes != null)
        .map((bytes) => base64Encode(bytes!))
        .toList();
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
              ImageList(imageBytesList: _imageBytesList),
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
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SubmitButton(onSubmit: () {
                    List<String> base64Images =
                        _convertToBase64(_imageBytesList);

                    Posting posting = Posting(
                      eventId: widget.event!.eventId,
                      eventDate: widget.selectedDay ?? "Null",
                      content: _textController.text,
                      files: base64Images,
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
  final List<Uint8List?> imageBytesList;

  const ImageList({required this.imageBytesList, super.key});

  @override
  Widget build(BuildContext context) {
    return imageBytesList.isEmpty
        ? Container()
        : SizedBox(
            height: 150.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageBytesList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: imageBytesList[index] != null
                      ? Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(imageBytesList[index]!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const Text('이미지 로딩 에러'),
                );
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
