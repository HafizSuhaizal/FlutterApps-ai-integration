import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/model_service.dart';
import '../models/image_model.dart';

class ImageController {
  final ImagePicker _picker = ImagePicker();
  final ModelService _modelService = ModelService();

  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print('Image selected: ${pickedFile.path}');
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<ImageModel> classifyImage(File image) async {
    try {
      return await _modelService.classifyImage(image);
    } catch (e) {
      print('Error in classifyImage: $e');
      rethrow;
    }
  }
}
