import 'package:hive/hive.dart';

part 'history_model.g.dart'; // HARUS ada

@HiveType(typeId: 0)
class HistoryModel extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late DateTime translateDate;

  @HiveField(2)
  late List<String> imagePaths;

  @HiveField(3)
  late int id; // ID tambahan (misalnya index ke-n dari box)

  HistoryModel({
    required this.title,
    required this.translateDate,
    required this.imagePaths,
    required this.id,
  });
}
