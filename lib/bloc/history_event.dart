part of 'history_bloc.dart';

sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadHistory extends HistoryEvent {}

class AddHistory extends HistoryEvent {
  final String title;
  final List<MangaImageModel> imagePaths;

  const AddHistory(this.title, this.imagePaths);
}

class DeleteHistory extends HistoryEvent {
  final int id;
  const DeleteHistory(this.id);
}

class DeleteMultipleHistory extends HistoryEvent {
  final List<int> ids;
  const DeleteMultipleHistory(this.ids);
}
