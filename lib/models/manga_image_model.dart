import 'package:equatable/equatable.dart';

class MangaImageModel extends Equatable {
  final String? path;
  final int? index;
  final bool isTranslated;

  const MangaImageModel({this.path, this.index, this.isTranslated = false});

  factory MangaImageModel.fromJson(Map<String, dynamic> json) {
    return MangaImageModel(path: json['path'], index: json['index']);
  }

  Map<String, dynamic> toJson() {
    return {'path': path, 'index': index};
  }

  @override
  List<Object?> get props => [path];
}
