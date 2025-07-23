import 'package:flutter/material.dart';
import 'package:manga_translator/models/manga_image_model.dart';
import 'package:manga_translator/modules/history_detail/body/history_detail_body.dart';

class HistoryDetailScreen extends StatelessWidget {
  final String title;
  final DateTime translateDate;
  final List<MangaImageModel> imagePaths;
  const HistoryDetailScreen({
    super.key,
    required this.title,
    required this.translateDate,
    required this.imagePaths,
  });

  @override
  Widget build(BuildContext context) {
    return HistoryDetailBody(
      title: title,
      translateDate: translateDate,
      imagePaths: imagePaths,
    );
  }
}
