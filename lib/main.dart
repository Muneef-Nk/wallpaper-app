import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/features/wallpaper/views/splash_screen.dart';

import 'features/wallpaper/controller/photo_controller.dart';

void main() {
  runApp(const WallpaperApp());
}

class WallpaperApp extends StatelessWidget {
  const WallpaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WallpaperController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wallpaper App',
        home: SplashScreen(),
      ),
    );
  }
}
