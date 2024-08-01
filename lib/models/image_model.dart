class ImageModel {
  final String className;
  final double confidence;

  ImageModel({required this.className, required this.confidence});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      className: json['class'],
      confidence: json['confidence'],
    );
  }
}
