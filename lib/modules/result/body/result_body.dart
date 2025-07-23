import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga_translator/bloc/history_bloc.dart';
import 'package:manga_translator/bloc/manga_image_bloc.dart';
import 'package:manga_translator/models/manga_image_model.dart';
import 'package:manga_translator/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path/path.dart' as path;

class ResultBody extends StatefulWidget {
  const ResultBody({super.key});

  @override
  State<ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<ResultBody> {
  MangaImageBloc? mangaImageBloc;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    mangaImageBloc = context.read<MangaImageBloc>();
  }

  void _removeImages() {
    mangaImageBloc!.add(RemoveImages());
  }

  Future<void> showDownloadDialog(
    BuildContext context,
    List<MangaImageModel> results,
  ) async {
    final titleController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Nama Folder"),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: "Masukkan nama folder untuk disimpan",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // batal
            child: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              final title = titleController.text.trim();
              if (title.isEmpty) return;

              setState(() {
                isSaving = true;
              });

              await Future.delayed(const Duration(seconds: 3));

              await saveAllWithTitle(context, results, title);

              Navigator.of(context).pop(); // tutup dialog

              if (context.mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Gambar dan riwayat berhasil disimpan."),
                    ),
                  );
                });
              }

              setState(() {
                isSaving = false;
              });
            },
            child: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  Future<void> saveAllWithTitle(
    BuildContext context,
    List<MangaImageModel> results,
    String title,
  ) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin penyimpanan tidak diberikan.")),
      );
      return;
    }

    final safeFolderName = title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final folder = Directory('/storage/emulated/0/Download/$safeFolderName');
    if (!folder.existsSync()) {
      await folder.create(recursive: true);
    }

    final List<MangaImageModel> savedImages = [];
    for (int i = 0; i < results.length; i++) {
      final file = File(results[i].path!);
      final fileName = 'page_$i.png';
      final targetPath = '${folder.path}/$fileName';

      try {
        await file.copy(targetPath);
        savedImages.add(MangaImageModel(path: targetPath, index: i));
      } catch (e) {
        print("Gagal menyimpan gambar $i: $e");
      }
    }

    if (context.mounted) {
      context.read<HistoryBloc>().add(AddHistory(title, savedImages));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gambar dan riwayat berhasil disimpan.")),
    );
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

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          BlocBuilder<MangaImageBloc, MangaImageState>(
            builder: (context, state) {
              if (state is MangaImageLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MangaImageFailed) {
                return Text(state.textFailed!);
              } else if (state is MangaImageLoaded) {
                final images = state.response;

                return ListView.builder(
                  itemCount: images.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final image = images[index];
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
                );
              }
              return Container();
            },
          ),
        ],
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
        title: Text(
          "App Title",
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            _removeImages();
            Navigator.of(context).pushReplacementNamed(homeRoute);
          },
          icon: Icon(Icons.arrow_back, size: 24),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final state = context.read<MangaImageBloc>().state;
              if (state is MangaImageLoaded) {
                showDownloadDialog(context, state.response);
              }
            },
            icon: const Icon(Icons.download),
            tooltip: 'Download Semua',
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
