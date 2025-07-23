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

  @override
  void initState() {
    super.initState();
    mangaImageBloc = context.read<MangaImageBloc>();
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _elapsedSeconds = now.difference(_startTime).inSeconds;
      });
    });
    _onUploadImagesManga();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<MangaImageBloc, MangaImageState>(
        listener: (context, state) {
          if (state is MangaImageLoading) {
            print("Loading");
          }
          if (state is MangaImageLoaded) {
            Navigator.of(
              context,
            ).pushReplacementNamed(resultRoute, arguments: state.response);
          } else if (state is MangaImageFailed) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.textFailed!)));
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return _body();
        },
      ),
    );
  }
}
