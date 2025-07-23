part of 'manga_image_bloc.dart';

abstract class MangaImageEvent extends Equatable {
  const MangaImageEvent();

  @override
  List<Object> get props => [];
}

class AddImages extends MangaImageEvent {
  final List<String> paths;
  const AddImages(this.paths);

  @override
  List<Object> get props => [paths];
}

class UploadImages extends MangaImageEvent {
  const UploadImages();

  @override
  List<Object> get props => [];
}

class RemoveImage extends MangaImageEvent {
  final int index;

  const RemoveImage(this.index);

  @override
  List<Object> get props => [index];
}

class RemoveImages extends MangaImageEvent {
  @override
  List<Object> get props => [];
}
