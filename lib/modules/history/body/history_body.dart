import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga_translator/bloc/history_bloc.dart';
import 'package:manga_translator/models/manga_image_model.dart';
import 'package:manga_translator/modules/history/item/history_card.dart';
import 'package:manga_translator/routes/routes.dart';

class HistoryBody extends StatefulWidget {
  const HistoryBody({super.key});

  @override
  State<HistoryBody> createState() => _HistoryBodyState();
}

class _HistoryBodyState extends State<HistoryBody> {
  HistoryBloc? historyBloc;
  bool selectionMode = false;
  Set<int> selectedIds = {};

  @override
  void initState() {
    super.initState();
    historyBloc = context.read<HistoryBloc>();
    _getAllHistory();
  }

  void _getAllHistory() {
    historyBloc!.add(LoadHistory());
  }

  Widget _body() {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HistoryLoaded) {
          final histories = state.response;

          histories.sort((a, b) => b.translateDate.compareTo(a.translateDate));
          if (histories.isEmpty) {
            return Align(
              alignment: Alignment.center,
              child: Text(
                "Tidak Ada History Penerjemahan",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: histories.length,
            padding: const EdgeInsets.only(top: 30),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = histories[index];

              // Decode dari JSON ke List<MangaImageModel>
              final imageModels = item.imagePaths
                  .map((path) => MangaImageModel(path: path))
                  .toList();

              return HistoryCard(
                title: item.title,
                translateDate: item.translateDate,
                imagePaths: imageModels,
                color: selectedIds.contains(item.id)
                    ? Colors.grey.shade200
                    : Colors.white,
                onTap: () {
                  if (selectionMode) {
                    setState(() {
                      if (selectedIds.contains(item.id)) {
                        selectedIds.remove(item.id);
                        if (selectedIds.isEmpty) selectionMode = false;
                      } else {
                        selectedIds.add(item.id);
                      }
                    });
                  } else {
                    Navigator.pushNamed(
                      context,
                      historyDetailRoute,
                      arguments: {
                        'title': item.title,
                        'translateDate': item.translateDate,
                        'imagePaths': imageModels,
                      },
                    );
                  }
                },
                onLongPress: () {
                  setState(() {
                    selectionMode = true;
                    selectedIds.add(item.id);
                  });
                },
              );
            },
          );
        } else if (state is HistoryFailed) {
          return Center(child: Text(state.textFailed!));
        }

        return Container();
      },
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
        title: selectionMode
            ? Text("${selectedIds.length} dipilih", style: GoogleFonts.roboto())
            : Text(
                "History",
                style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
              ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, size: 24),
        ),
        actions: [
          if (selectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Hapus semua id yang dipilih
                context.read<HistoryBloc>().add(
                  DeleteMultipleHistory(selectedIds.toList()),
                );
                setState(() {
                  selectionMode = false;
                  selectedIds.clear();
                });
              },
            ),
        ],
        automaticallyImplyLeading: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0, color: Colors.black),
        ),
      ),
      body: SafeArea(child: _body()),
    );
  }
}
