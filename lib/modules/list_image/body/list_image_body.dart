import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga_translator/bloc/manga_image_bloc.dart';
import 'package:manga_translator/config/app_color.dart';
import 'package:manga_translator/routes/routes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class ListImageBody extends StatefulWidget {
  const ListImageBody({super.key});

  @override
  State<ListImageBody> createState() => _ListImageBodyState();
}

class _ListImageBodyState extends State<ListImageBody> {
  MangaImageBloc? mangaImageBloc;

  @override
  void initState() {
    super.initState();
    mangaImageBloc = context.read<MangaImageBloc>();
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

  void _removeImages() {
    mangaImageBloc!.add(RemoveImages());
  }

  Widget headerAddImages() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
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
              return Text(
                "Gambar yang dipilih (0)",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              setState(() {
                pickFileAndAdd(context);
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
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            headerAddImages(),
            BlocBuilder<MangaImageBloc, MangaImageState>(
              builder: (context, state) {
                if (state is MangaImageLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                // else if (state is MangaImageFailed) {
                //   return SnackBar(
                //     content: Text('Gambar tidak boleh lebih dari 4'),
                //     duration: Duration(seconds: 4),
                //   );
                // }
                else if (state is MangaImageLoaded) {
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
                                        RemoveImage(index),
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
                                  Navigator.pushReplacementNamed(
                                    context,
                                    loadingRoute,
                                    arguments: images,
                                  );
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        centerTitle: true,
        title: Text(
          "List Image",
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            _removeImages();
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, size: 24, color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.white, height: 1.0),
        ),
      ),
      body: _body(),
    );
  }
}
