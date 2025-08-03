part of 'manga_image_bloc.dart';

sealed class MangaImageState extends Equatable {
  const MangaImageState();

  @override
  List<Object> get props => [];

  void add(List<String> paths, int index) {}
}

class MangaImageInitState extends MangaImageState {}

class MangaImageLoading extends MangaImageState {}

class MangaImageLoaded extends MangaImageState {
  final List<MangaImageModel> response;

  const MangaImageLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class MangaImageFailed extends MangaImageState {
  final String textFailed;
  final List<MangaImageModel> originalImages;

  const MangaImageFailed({
    required this.textFailed,
    this.originalImages = const [],
  });

  @override
  List<Object> get props => [textFailed, originalImages];
}
