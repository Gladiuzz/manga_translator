import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manga_translator/models/history_model.dart';
import 'package:manga_translator/models/manga_image_model.dart';
import 'package:manga_translator/repositories/history_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository repository;

  HistoryBloc({required this.repository}) : super(HistoryInitialState()) {
    on<LoadHistory>((event, emit) async {
      emit(HistoryLoading());
      try {
        final list = await repository.getAll();
        emit(HistoryLoaded(response: list));
      } catch (e) {
        emit(HistoryFailed(textFailed: "Gagal memuat riwayat"));
      }
    });

    on<AddHistory>((event, emit) async {
      await repository.saveHistory(event.title, event.imagePaths);
      add(LoadHistory());
    });

    on<DeleteHistory>((event, emit) async {
      await repository.deleteHistory(event.id);
      add(LoadHistory());
    });

    on<DeleteMultipleHistory>((event, emit) async {
      await repository.deleteMultiple(event.ids);
      add(LoadHistory());
    });
  }
}
