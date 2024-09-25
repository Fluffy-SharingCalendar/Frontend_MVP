import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class PostArticlePage extends StatefulWidget {
  const PostArticlePage({
    super.key,
  });

  @override
  State<PostArticlePage> createState() => _PostArticlePageState();
}

class _PostArticlePageState extends State<PostArticlePage> {
  List<Uint8List?> _imageBytesList = [];

  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _imageBytesList = result.files.map((file) => file.bytes).toList();
      });
    } else {
      print('No images selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("file picker 실습"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
          ),
          width: screenSize.width * 0.5,
          height: screenSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _imageBytesList.isEmpty
                  ? Container()
                  : Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imageBytesList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _imageBytesList[index] != null
                                ? SizedBox(
                                    width: 150.0,
                                    height: 150.0,
                                    child: Image.memory(
                                      _imageBytesList[index]!,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : const Text('Error loading image'),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImages,
                child: const Text('Pick Images'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
