import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga_translator/bloc/history_bloc.dart';
import 'package:manga_translator/bloc/manga_image_bloc.dart';
import 'package:manga_translator/models/history_model.dart';
import 'package:manga_translator/repositories/history_repository.dart';
import 'package:manga_translator/repositories/manga_image_repository.dart';
import 'package:manga_translator/routes/routes.dart';
import 'package:manga_translator/routes/routes_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request();
  await Hive.initFlutter();
  Hive.registerAdapter(HistoryModelAdapter());
  await Hive.openBox<HistoryModel>('history');
  final box = await Hive.openBox<HistoryModel>('history');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MangaImageBloc(repository: MangaImageService()),
        ),
        BlocProvider(
          create: (_) => HistoryBloc(repository: HistoryService(box)),
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
