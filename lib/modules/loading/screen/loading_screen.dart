import 'package:flutter/material.dart';
import 'package:manga_translator/modules/loading/body/loading_body.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return LoadingBody();
  }
}
