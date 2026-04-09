import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manga_translator/models/manga_image_model.dart';

class HistoryCard extends StatelessWidget {
  final String title;
  final int id;
  final DateTime translateDate;
  final List<MangaImageModel> imagePaths;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? color;

  const HistoryCard({
    super.key,
    required this.title,
    required this.translateDate,
    required this.imagePaths,
    required this.onTap,
    required this.onLongPress,
    required this.color,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMMM yyyy').format(translateDate);

    return Padding(
      padding: const EdgeInsets.only(left: 41, right: 41, bottom: 20),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imagePaths.isNotEmpty
                      ? Container(
                          width: 61,
                          height: 61,
                          alignment: Alignment.center,
                          child: Image.file(
                            File(imagePaths.first.path!),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          width: 61,
                          height: 61,
                          color: Colors.grey.shade400,
                          alignment: Alignment.center,
                          child: const Text(
                            "Thumbnail\nManga",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                // Detail
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${imagePaths.length} gambar yang diterjemahkan",
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
