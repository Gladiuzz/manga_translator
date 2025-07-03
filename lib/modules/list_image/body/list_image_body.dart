import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manga_translator/bloc/manga_image_bloc.dart';
import 'package:manga_translator/routes/routes.dart';

class ListImageBody extends StatefulWidget {
  const ListImageBody({super.key});

  @override
  State<ListImageBody> createState() => _ListImageBodyState();
}

class _ListImageBodyState extends State<ListImageBody> {
  MangaImageBloc? mangaImageBloc;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    mangaImageBloc = context.read<MangaImageBloc>();
  }

  Future<void> pickImageAndAdd(BuildContext context) async {
    final state = context.read<MangaImageBloc>().state;
    int currentCount = 0;
    if (state is MangaImageLoaded) {
      currentCount = state.response.length;
    }

    const maxImages = 4;
    final remaining = maxImages - currentCount;

    if (remaining <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maksimal 4 gambar yang boleh diupload')),
      );
      return;
    }

    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isEmpty) {
      return;
    }

    // Ambil hanya sejumlah yang dibolehkan
    final limitedFiles = pickedFiles.take(remaining).toList();
    final paths = limitedFiles.map((xfile) => xfile.path).toList();

    context.read<MangaImageBloc>().add(AddImages(paths));
  }

  Widget headerAddImages() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BlocBuilder<MangaImageBloc, MangaImageState>(
            builder: (context, state) {
              if (state is MangaImageLoaded) {
                return Text(
                  "Gambar yang dipilih (${state.response.length})",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                );
              }
              return Container(
                child: Text(
                  "Gambar yang dipilih (0)",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              setState(() {
                pickImageAndAdd(context);
              });
            },
            icon: Icon(Icons.add, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          headerAddImages(),
          SizedBox(height: 26.0),
          BlocBuilder<MangaImageBloc, MangaImageState>(
            builder: (context, state) {
              if (state is MangaImageLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MangaImageFailed) {
                return SnackBar(
                  content: Text('Gambar tidak boleh lebih dari 4'),
                  duration: Duration(seconds: 4),
                );
              } else if (state is MangaImageLoaded) {
                final images = state.response;

                return Column(
                  children: [
                    SingleChildScrollView(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: images.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                            ),
                        itemBuilder: (context, index) {
                          final image = images[index];
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(image.path!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<MangaImageBloc>().add(
                                      RemoveImages(index),
                                    );
                                  },
                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // Tombol Menerjemahkan tetap di luar GridView
                    images.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                // Fungsi translate
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed(loadingRoute);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: const BorderSide(color: Colors.black),
                              ),
                              child: const Text("Menerjemahkan"),
                            ),
                          )
                        : Container(),
                  ],
                );
              } else {
                return Container();
              }
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
        title: Text(
          "App Title",
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
