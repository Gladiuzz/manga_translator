import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_translator/bloc/manga_image_bloc.dart';
import 'package:manga_translator/modules/home/screen/home_screen.dart';
import 'package:manga_translator/routes/routes.dart';
import 'package:manga_translator/routes/routes_generator.dart';

void main() async {
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => MangaImageBloc())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Test",
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RoutesGenerator.generateRoute,
      initialRoute: homeRoute,
    );
  }
}
