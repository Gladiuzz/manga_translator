import 'package:isar/isar.dart';

part 'history_model.g.dart';

@collection
class HistoryModel {
  Id id = Isar.autoIncrement;

  late String title;
  late DateTime translateDate;
  late String imagePaths;
}
