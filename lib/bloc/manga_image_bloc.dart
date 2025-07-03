import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manga_translator/models/manga_image_model.dart';

part 'manga_image_event.dart';
part 'manga_image_state.dart';

class MangaImageBloc extends Bloc<MangaImageEvent, MangaImageState> {
  MangaImageBloc() : super(MangaImageInitState()) {
    on<AddImages>(_onAddImages);
    on<RemoveImages>(_onRemoveImage);
  }

  Future<void> _onAddImages(
    AddImages event,
    Emitter<MangaImageState> emit,
  ) async {
    // Ambil list saat ini jika sudah ada, atau buat list kosong
    final currentList = state is MangaImageLoaded
        ? List<MangaImageModel>.from((state as MangaImageLoaded).response)
        : <MangaImageModel>[];

    // Gabungkan list sekarang dengan gambar baru dari event (tanpa filter duplikat)
    final newList = [
      ...currentList,
      ...event.paths.map((path) => MangaImageModel(path: path)),
    ];

    emit(MangaImageLoaded(response: newList));
  }

  Future<void> _onRemoveImage(
    RemoveImages event,
    Emitter<MangaImageState> emit,
  ) async {
    if (state is MangaImageLoaded) {
      final currentList = List<MangaImageModel>.from(
        (state as MangaImageLoaded).response,
      );
      if (event.index >= 0 && event.index < currentList.length) {
        currentList.removeAt(event.index);
        emit(MangaImageLoaded(response: currentList));
      }
    }
  }
}
