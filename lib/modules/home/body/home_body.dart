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
    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isEmpty) return false;

    final paths = pickedFiles.map((xfile) => xfile.path).toList();

    mangaImageBloc!.add(AddImages(paths));
    return true;
  }

  Widget _body() {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.6;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isLoading
              ? CircularProgressIndicator()
              : SizedBox(
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
    return Scaffold(backgroundColor: Colors.white, body: _body());
  }
}
