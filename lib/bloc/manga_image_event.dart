part of 'manga_image_bloc.dart';

sealed class MangaImageEvent extends Equatable {
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

class RemoveImages extends MangaImageEvent {
  final int index;

  const RemoveImages(this.index);

  @override
  List<Object> get props => [index];
}
