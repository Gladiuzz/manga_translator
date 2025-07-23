import 'package:flutter/material.dart';
import 'package:manga_translator/models/manga_image_model.dart';
import 'package:manga_translator/modules/history/screen/history_screen.dart';
import 'package:manga_translator/modules/history_detail/screen/history_detail_screen.dart';
import 'package:manga_translator/modules/home/screen/home_screen.dart';
import 'package:manga_translator/modules/list_image/screen/list_image_screen.dart';
import 'package:manga_translator/modules/loading/screen/loading_screen.dart';
import 'package:manga_translator/modules/result/screen/result_screen.dart';
import 'package:manga_translator/routes/routes.dart';

class RoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        const screen = HomeScreen();
        return MaterialPageRoute(builder: (_) => screen);
      case listImageRoute:
        const screen = ListImageScreen();
        return MaterialPageRoute(builder: (_) => screen);
      case loadingRoute:
        const screen = LoadingScreen();
        return MaterialPageRoute(builder: (_) => screen);
      case resultRoute:
        const screen = ResultScreen();
        return MaterialPageRoute(builder: (_) => screen);
      case historyRoute:
        const screen = HistoryScreen();
        return MaterialPageRoute(builder: (_) => screen);
      case historyDetailRoute:
        final args = settings.arguments as Map<String, dynamic>;
        final screen = HistoryDetailScreen(
          title: args['title'] as String,
          translateDate: args['translateDate'] as DateTime,
          imagePaths: (args['imagePaths'] as List).cast<MangaImageModel>(),
        );
        return MaterialPageRoute(builder: (_) => screen);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text("Tidak ada Route ${settings.name}")),
          ),
        );
    }
  }
}
