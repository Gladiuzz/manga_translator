import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manga_translator/bloc/manga_image_bloc.dart';
import 'package:manga_translator/routes/routes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  MangaImageBloc? mangaImageBloc;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    mangaImageBloc = context.read<MangaImageBloc>();
  }

  Future<void> showLoadingDialog(BuildContext context, {String? message}) {
    return showDialog(
      context: context,
      barrierDismissible: false, // tidak bisa ditutup dengan tap di luar
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message ?? "Memproses...",
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onTranslatePressed(BuildContext context) async {
    // Pilih gambar
    final success = await pickFileAndAdd(context);

    if (!success) return;

    // Tampilkan dialog loading hanya jika gambar berhasil dipilih
    showLoadingDialog(context);

    // Simulasi proses atau bisa diganti dengan pemanggilan API
    await Future.delayed(const Duration(seconds: 2));

    // Tutup loading dan navigasi ke halaman list image
    if (context.mounted) {
      Navigator.of(context).pop(); // Tutup loading dialog
      Navigator.of(context).pushNamed(listImageRoute);
    }
  }

  Future<bool> pickFileAndAdd(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result == null || result.files.isEmpty) return false;

    List<String> allImagePaths = [];

    for (final file in result.files) {
      final ext = file.extension?.toLowerCase();
      final filePath = file.path!;
      if (ext == 'jpg' || ext == 'jpeg' || ext == 'png') {
        // Jika file gambar, langsung masukkan
        allImagePaths.add(filePath);
      } else if (ext == 'pdf') {
        // Jika PDF, ekstrak semua halaman jadi gambar pakai pdfx
        final document = await PdfDocument.openFile(filePath);
        final tempDir = await getTemporaryDirectory();

        for (int i = 1; i <= document.pagesCount; i++) {
          final page = await document.getPage(i);
          final pageImage = await page.render(
            width: page.width,
            height: page.height,
            format: PdfPageImageFormat.png,
          );
          final tempFile = File('${tempDir.path}/${file.name}_page_$i.png');
          await tempFile.writeAsBytes(pageImage!.bytes);
          allImagePaths.add(tempFile.path);
          await page.close();
        }
        await document.close();
      }
    }

    if (allImagePaths.isEmpty) return false;

    mangaImageBloc!.add(AddImages(allImagePaths));
    return true;
  }

  Widget _body() {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.6;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: buttonWidth,
            child: ElevatedButton.icon(
              icon: Icon(Icons.upload, size: 24),
              label: Text(
                "Upload Image",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              onPressed: () async {
                onTranslatePressed(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                iconColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.black),
                ),
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: 16,
                  right: 16,
                ),
                elevation: 0,
              ),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: buttonWidth,
            child: ElevatedButton.icon(
              icon: Icon(Icons.history, size: 24),
              label: Text(
                "History Translation",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pushNamed(historyRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                iconColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.black),
                ),
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: 16,
                  right: 16,
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(),
      resizeToAvoidBottomInset: true,
    );
  }
}
