import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:manga_translator/bloc/history_bloc.dart';
import 'package:manga_translator/bloc/manga_image_bloc.dart';
import 'package:manga_translator/models/history_model.dart';
import 'package:manga_translator/repositories/history_repository.dart';
import 'package:manga_translator/repositories/manga_image_repository.dart';
import 'package:manga_translator/routes/routes.dart';
import 'package:manga_translator/routes/routes_generator.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([HistoryModelSchema], directory: dir.path);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MangaImageBloc(repository: MangaImageService()),
        ),
        BlocProvider(
          create: (_) => HistoryBloc(repository: HistoryService(isar)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Manga Translator",
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RoutesGenerator.generateRoute,
      initialRoute: homeRoute,
    );
  }
}
