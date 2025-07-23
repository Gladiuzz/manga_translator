import 'package:flutter/material.dart';
import 'package:manga_translator/modules/list_image/body/list_image_body.dart';

class ListImageScreen extends StatefulWidget {
  const ListImageScreen({super.key});

  @override
  State<ListImageScreen> createState() => _ListImageScreenState();
}

class _ListImageScreenState extends State<ListImageScreen> {
  @override
  Widget build(BuildContext context) {
    return ListImageBody();
  }
}
