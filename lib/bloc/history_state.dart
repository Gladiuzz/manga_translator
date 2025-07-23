part of 'history_bloc.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitialState extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryModel> response;

  const HistoryLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class HistoryFailed extends HistoryState {
  final String? textFailed;

  const HistoryFailed({this.textFailed});
}
