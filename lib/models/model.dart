class ImageModel {
  final int imageID;
  final String imageAlt;
  final String imagePotraitPath;

  const ImageModel({
    required this.imageID,
    required this.imageAlt,
    required this.imagePotraitPath,
  });
  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        imageID: json["id"] as int,
        imageAlt: json["alt"] as String,
        imagePotraitPath: json["src"]["portrait"] as String,
      );
}
