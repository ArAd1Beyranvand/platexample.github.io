import 'package:flutter/material.dart';

import '../poster/poster_tokens.dart';
import '../screens/gallery_shell_screen.dart';

class PlateNumberShowcaseApp extends StatelessWidget {
  const PlateNumberShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plate Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: PosterTokens.accent,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: PosterColors.pageBlack,
        canvasColor: PosterColors.pageBlack,
        useMaterial3: true,
      ),
      home: const GalleryShellScreen(),
    );
  }
}
