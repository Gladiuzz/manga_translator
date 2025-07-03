import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingBody extends StatefulWidget {
  const LoadingBody({super.key});

  @override
  State<LoadingBody> createState() => _LoadingBodyState();
}

class _LoadingBodyState extends State<LoadingBody> {
  Widget _body() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Loading",
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 100),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                minHeight: 6,
                backgroundColor: Colors.black12,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "sedang menerjemahkan",
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tahap menerjemahkan perlu waktu",
            style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey),
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
