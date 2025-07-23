import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_translator/models/manga_image_model.dart';
import 'package:manga_translator/repositories/manga_image_repository.dart';
import 'package:equatable/equatable.dart';

part 'manga_image_event.dart';
part 'manga_image_state.dart';

class MangaImageBloc extends Bloc<MangaImageEvent, MangaImageState> {
  final MangaImageRepository repository;
  List<MangaImageModel> originalImages = [];

  MangaImageBloc({required this.repository}) : super(MangaImageInitState()) {
    on<AddImages>(_onAddImages);
    on<UploadImages>(_onUploadImages);
    on<RemoveImage>(_onRemoveImage);
    on<RemoveImages>(_onRemoveImages);
  }

  Future<void> _onAddImages(
    AddImages event,
    Emitter<MangaImageState> emit,
  ) async {
    final currentList = state is MangaImageLoaded
        ? List<MangaImageModel>.from((state as MangaImageLoaded).response)
        : <MangaImageModel>[];

    final newList = [
      ...currentList,
      ...event.paths.map((path) => MangaImageModel(path: path)),
    ];

    originalImages = newList;
    emit(MangaImageLoaded(response: newList));
  }

  Future<void> _onUploadImages(
    UploadImages event,
    Emitter<MangaImageState> emit,
  ) async {
    if (originalImages.isEmpty) {
      emit(
        const MangaImageFailed(
          textFailed: "Tidak ada gambar untuk diterjemahkan.",
        ),
      );
      return;
    }

    emit(MangaImageLoading());
    final List<MangaImageModel> translatedResults = [];

    for (final image in originalImages) {
      final file = await repository.uploadImage(image);
      if (file != null) {
        translatedResults.add(
          MangaImageModel(path: file.path, index: image.index),
        );
      }
    }

    if (translatedResults.isNotEmpty) {
      emit(MangaImageLoaded(response: translatedResults));
    } else {
      emit(
        const MangaImageFailed(textFailed: "Gagal menerjemahkan semua gambar."),
      );
    }
  }

  Future<void> _onRemoveImage(
    RemoveImage event,
    Emitter<MangaImageState> emit,
  ) async {
    if (state is MangaImageLoaded) {
      final currentList = List<MangaImageModel>.from(
        (state as MangaImageLoaded).response,
      );
      if (event.index >= 0 && event.index < currentList.length) {
        currentList.removeAt(event.index);
        originalImages = currentList; // update juga di originalImages
        emit(MangaImageLoaded(response: currentList));
      }
    }
  }

  Future<void> _onRemoveImages(
    RemoveImages event,
    Emitter<MangaImageState> emit,
  ) async {
    originalImages.clear();
    emit(const MangaImageLoaded(response: []));
  }
}
