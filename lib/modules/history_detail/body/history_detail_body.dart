import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manga_translator/models/manga_image_model.dart';
import 'package:photo_view/photo_view.dart';

class HistoryDetailBody extends StatefulWidget {
  final String title;
  final DateTime translateDate;
  final List<MangaImageModel> imagePaths;
  const HistoryDetailBody({
    super.key,
    required this.title,
    required this.translateDate,
    required this.imagePaths,
  });

  @override
  State<HistoryDetailBody> createState() => _HistoryDetailBodyState();
}

class _HistoryDetailBodyState extends State<HistoryDetailBody> {
  @override
  void initState() {
    super.initState();
  }

  void _openFullImage(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: PhotoView(
              imageProvider: FileImage(File(imagePath)),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
              initialScale: PhotoViewComputedScale.contained,
            ),
          ),
        ),
      ),
    );
  }

  void _showMetaDialog(BuildContext context) {
    final formattedDate = DateFormat(
      'dd MMMM yyyy',
    ).format(widget.translateDate);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Info Translasi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Judul: ${widget.title}', style: GoogleFonts.roboto()),
              const SizedBox(height: 8),
              Text('Tanggal: $formattedDate', style: GoogleFonts.roboto()),
              const SizedBox(height: 8),
              Text(
                'Path Gambar:',
                style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...widget.imagePaths.map(
                (img) => Text(
                  "- ${img.path}",
                  style: GoogleFonts.roboto(fontSize: 12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: widget.imagePaths.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final image = widget.imagePaths[index];
          return GestureDetector(
            onTap: () => _openFullImage(context, image.path!),
            child: Container(
              padding: EdgeInsets.only(bottom: 22),
              child: InteractiveViewer(
                scaleEnabled: true, // Nonaktifkan zoom
                panEnabled: true, // Aktifkan drag
                child: Image.file(
                  File(image.path!),
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "History Detail",
          style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, size: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showMetaDialog(context),
            tooltip: "Info Translasi",
          ),
        ],
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black, height: 1.0),
        ),
      ),
      body: _body(),
    );
  }
}
