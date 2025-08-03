import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:manga_translator/models/history_model.dart';
import 'package:manga_translator/models/manga_image_model.dart';

abstract class HistoryRepository {
  Future<void> saveHistory(String title, List<MangaImageModel> imagePaths);
  Future<List<HistoryModel>> getAll();
  Future<void> deleteHistory(int index);
  Future<void> deleteMultiple(List<int> indexes);
}

class HistoryService implements HistoryRepository {
  final Box<HistoryModel> box;

  HistoryService(this.box);

  @override
  Future<void> saveHistory(
    String title,
    List<MangaImageModel> imagePaths,
  ) async {
    final nextId = box.length;

    // Ambil hanya path-nya saja
    final pathList = imagePaths.map((e) => e.path ?? '').toList();

    final history = HistoryModel(
      title: title,
      translateDate: DateTime.now(),
      imagePaths: pathList, // << List<String>
      id: nextId,
    );

    await box.add(history);
  }

  @override
  Future<List<HistoryModel>> getAll() async {
    return box.values.toList()
      ..sort((a, b) => b.translateDate.compareTo(a.translateDate));
  }

  @override
  Future<void> deleteHistory(int index) async {
    await box.deleteAt(index);
  }

  Future<void> deleteWithFiles(int index) async {
    final item = box.getAt(index);
    if (item != null) {
      try {
        final firstImagePath = item.imagePaths.isNotEmpty
            ? item.imagePaths.first
            : null;
        final folder = firstImagePath != null
            ? File(firstImagePath).parent
            : null;

        for (var path in item.imagePaths) {
          final file = File(path);
          if (file.existsSync()) await file.delete();
        }

        if (folder != null && folder.existsSync()) {
          final contents = folder.listSync();
          if (contents.isEmpty) await folder.delete();
        }
      } catch (e) {
        print("Gagal menghapus file atau folder: $e");
      }

      await box.deleteAt(index);
    }
  }

  @override
  Future<void> deleteMultiple(List<int> indexes) async {
    for (final index in indexes) {
      await deleteWithFiles(index);
    }
  }
}
