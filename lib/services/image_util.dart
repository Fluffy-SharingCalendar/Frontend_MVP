import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';

class ImageUtil {
  static Future<http.MultipartFile> compressImageToMultipartFile(
      String fieldName, String imagePath) async {
    const int maxSizeInBytes = 1 * 1000000;
    double compressionQuality = 1.0;

    // 이미지 확장자와 파일 이름 설정
    String fileExtension = imagePath.split('.').last.toLowerCase();
    String mimeType;
    String filename;

    switch (fileExtension) {
      case 'jpg':
      case 'jpeg':
        mimeType = 'image/jpeg';
        filename = 'compressed_image.jpg';
        break;
      case 'png':
        mimeType = 'image/png';
        filename = 'compressed_image.png';
        break;
      default:
        throw UnsupportedError('Unsupported file format');
    }

    Future<List<int>> compressImage(double quality) async {
      return (await FlutterImageCompress.compressWithFile(
        imagePath,
        quality: (quality * 100).toInt(),
        format: _getCompressFormat(fileExtension),
      ))!;
    }

    List<int> imageData = await compressImage(1.0);

    // 이미지 용량이 초과될 경우, 반복해서 압축
    while (imageData.length > maxSizeInBytes && compressionQuality > 0) {
      compressionQuality -= 0.1;
      imageData = await compressImage(compressionQuality);
    }

    // 압축된 이미지 파일 반환
    return http.MultipartFile.fromBytes(
      fieldName,
      imageData,
      filename: filename,
      contentType: MediaType.parse(mimeType),
    );
  }

  // 파일 확장자에 따라 압축 형식 반환
  static CompressFormat _getCompressFormat(String fileExtension) {
    switch (fileExtension) {
      case 'jpg':
      case 'jpeg':
        return CompressFormat.jpeg;
      case 'png':
        return CompressFormat.png;
      default:
        throw UnsupportedError('Unsupported file format');
    }
  }
}
