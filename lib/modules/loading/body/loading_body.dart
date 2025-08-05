import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga_translator/bloc/manga_image_bloc.dart';
import 'package:manga_translator/models/manga_image_model.dart';
import 'package:manga_translator/routes/routes.dart';

class LoadingBody extends StatefulWidget {
  const LoadingBody({super.key});

  @override
  State<LoadingBody> createState() => _LoadingBodyState();
}

class _LoadingBodyState extends State<LoadingBody> {
  Timer? _timer;
  MangaImageBloc? mangaImageBloc;
  late DateTime _startTime;
  int _elapsedSeconds = 0;
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();

    mangaImageBloc = context.read<MangaImageBloc>();

    // Ambil list gambar dari argument saat navigasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is List<MangaImageModel> && args.isNotEmpty) {
        mangaImageBloc!.add(
          RemoveImages(),
        ); // clear dulu untuk mencegah duplikasi
        mangaImageBloc!.add(AddImages(args.map((e) => e.path!).toList()));
      }

      _onUploadImagesManga();
      _startTime = DateTime.now();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final now = DateTime.now();
        setState(() {
          _elapsedSeconds = now.difference(_startTime).inSeconds;
        });
      });
    });
  }

  void _onUploadImagesManga() {
    mangaImageBloc!.add(UploadImages());
  }

  String formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    if (minutes > 0) {
      return "$minutes menit ${seconds.toString().padLeft(1, '0')} detik";
    } else {
      return "$seconds detik";
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _body() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Loading",
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 100),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                minHeight: 6,
                backgroundColor: Colors.black12,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "sedang menerjemahkan",
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Waktu berjalan: ${formatDuration(_elapsedSeconds)}",
            style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<MangaImageBloc, MangaImageState>(
          listener: (context, state) async {
            if (state is MangaImageLoaded) {
              final images = state.response;

              final allTranslated =
                  images.isNotEmpty && images.every((img) => img.isTranslated);

              if (allTranslated) {
                _timer?.cancel(); // ❗Matikan timer sebelum pindah halaman
                Navigator.of(
                  context,
                ).pushReplacementNamed(resultRoute, arguments: images);
              }
            } else if (state is MangaImageFailed) {
              final text = state.textFailed ?? "";
              final failedImages = state.originalImages;

              if (_isDialogShown) return;
              _isDialogShown = true;

              final result = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Gagal"),
                  content: Text(text),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // return value = true
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );

              if (result == true) {
                _timer?.cancel(); // ❗Pastikan timer dimatikan
                context.read<MangaImageBloc>().add(RemoveImages());
                context.read<MangaImageBloc>().add(
                  AddImages(failedImages.map((e) => e.path!).toList()),
                );
                Navigator.of(context).pushReplacementNamed(listImageRoute);
                _isDialogShown = false;
              }
            }
          },
          builder: (context, state) {
            return _body(); // kode tampilannya
          },
        ),
      ),
    );
  }
}
