import 'package:flutter/material.dart';
import 'package:music_player_with_getx/presentation/pages/player_page.dart';

abstract class Routes {
  Routes._();

  static PageRoute goToPlayerPage({int? index}) {
    return MaterialPageRoute(builder: (_) =>  AudioPlayerPage(selectIndex: index ?? 0,));
  }

      
}
