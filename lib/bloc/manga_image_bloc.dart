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
      ...event.paths.map(
        (path) => MangaImageModel(path: path, isTranslated: false),
      ),
    ];

    emit(MangaImageLoaded(response: newList));
  }

  Future<void> _onUploadImages(
    UploadImages event,
    Emitter<MangaImageState> emit,
  ) async {
    final currentState = state;

    if (currentState is! MangaImageLoaded || currentState.response.isEmpty) {
      emit(
        const MangaImageFailed(
          textFailed: "Tidak ada gambar untuk diterjemahkan.",
        ),
      );
      return;
    }

    emit(MangaImageLoading());

    try {
      // Kirim SEMUA gambar dalam 1 request
      final paths = await repository.uploadImages(currentState.response);
      print("Uploaded paths: $paths");

      if (paths.isNotEmpty) {
        // Convert ke MangaImageModel kalau mau
        final translatedResults = [
          for (var i = 0; i < paths.length; i++)
            MangaImageModel(path: paths[i].path, index: i, isTranslated: true),
        ];
        emit(MangaImageLoaded(response: translatedResults));
      }
    } catch (e) {
      final message = e.toString().contains("Socket")
          ? "Tidak ada koneksi internet."
          : "Terjadi kesalahan saat mengunggah gambar.";
      emit(
        MangaImageFailed(
          textFailed: message,
          originalImages: currentState.response,
        ),
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
