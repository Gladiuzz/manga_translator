import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:manga_translator/models/history_model.dart';
import 'package:manga_translator/models/manga_image_model.dart';

abstract class HistoryRepository {
  Future<void> saveHistory(String title, List<MangaImageModel> imagePaths);
  Future<List<HistoryModel>> getAll();
  Future<void> deleteHistory(int index);
  Future<void> deleteMultiple(List<int> ids);
}

class HistoryService implements HistoryRepository {
  final Box<HistoryModel> box;

  HistoryService(this.box);

  @override
  Future<void> saveHistory(
    String title,
    List<MangaImageModel> imagePaths,
  ) async {
    // Ambil hanya path-nya saja
    final pathList = imagePaths.map((e) => e.path ?? '').toList();

    final history = HistoryModel(
      title: title,
      translateDate: DateTime.now(),
      imagePaths: pathList, // << List<String>
      id: 0, // placeholder
    );

    final key = await box.add(history);
    history.id = key;
    await history.save();
  }

  @override
  Future<List<HistoryModel>> getAll() async {
    return box.values.toList()
      ..sort((a, b) => b.translateDate.compareTo(a.translateDate));
  }

  @override
  Future<void> deleteHistory(int id) async {
    await _deleteWithFilesById(id);
  }

  Future<void> _deleteWithFilesById(int id) async {
    final item = box.get(id);
    print("id ${id} item: $item");
    if (item == null) return;

    try {
      // hapus semua file hasil terjemahan
      final firstImagePath = item.imagePaths.isNotEmpty
          ? item.imagePaths.first
          : null;
      final folder = firstImagePath != null
          ? File(firstImagePath).parent
          : null;

      for (final path in item.imagePaths) {
        final file = File(path);
        if (file.existsSync()) {
          await file.delete();
        }
      }

      // jika folder kosong, hapus juga
      if (folder != null && folder.existsSync()) {
        final contents = folder.listSync();
        if (contents.isEmpty) {
          await folder.delete();
        }
      }
    } catch (e) {
      print("Gagal menghapus file atau folder: $e");
    }

    // hapus record hive berdasarkan key
    await box.delete(id);
  }

  @override
  Future<void> deleteMultiple(List<int> ids) async {
    for (final id in ids) {
      await _deleteWithFilesById(id);
    }
  }
}
