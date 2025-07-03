import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manga_translator/bloc/manga_image_bloc.dart';
import 'package:manga_translator/routes/routes.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  MangaImageBloc? mangaImageBloc;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    mangaImageBloc = context.read<MangaImageBloc>();
  }

  Future<void> onTranslatePressed(BuildContext context) async {
    final success = await pickImageAndAdd(context);

    setState(() => isLoading = true);

    if (!success) {
      setState(() => isLoading = false);
      return;
    }

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => isLoading = false);
      Navigator.of(context).pushReplacementNamed(listImageRoute);
    }
  }

  Future<bool> pickImageAndAdd(BuildContext context) async {
    final state = context.read<MangaImageBloc>().state;
    int currentCount = 0;
    if (state is MangaImageLoaded) {
      currentCount = state.response.length;
    }

    const maxImages = 4;
    final remaining = maxImages - currentCount;

    if (remaining <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maksimal 4 gambar boleh dipilih.')),
      );
      return false;
    }

    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isEmpty) return false;

    final limitedFiles = pickedFiles.take(remaining).toList();
    final paths = limitedFiles.map((xfile) => xfile.path).toList();

    context.read<MangaImageBloc>().add(AddImages(paths));
    return true;
  }

  Widget _body() {
    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () async {
                onTranslatePressed(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.black),
                ),
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: 24,
                  right: 24,
                ),
                elevation: 0,
              ),
              child: Text(
                "Upload Image",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _body());
  }
}
