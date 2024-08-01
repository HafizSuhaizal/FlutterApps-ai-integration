import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';

class ModelService {
  Future<ImageModel> classifyImage(File image) async {
    final request = http.MultipartRequest('POST', Uri.parse('http://192.168.1.116:5000/predict'));
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final Map<String, dynamic> data = json.decode(responseData.body);
      return ImageModel.fromJson(data);
    } else {
      final responseData = await http.Response.fromStream(response);
      throw Exception('Failed to classify image: ${responseData.body}');
    }
  }
}
