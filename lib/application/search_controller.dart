import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../domain/model/music_model.dart';


class SearchController extends GetxController {
  MusicModel musicModel = MusicModel();

  getMusic(String name) async {
    try {
      final res = await Dio().get(
        "https://deezerdevs-deezer.p.rapidapi.com/search?q=$name",
        options: Options(
          headers: {
            "X-RapidAPI-Key":
                "91d31d4cb8mshdd2eaed2c3bf3b5p1bc6d3jsn9e4eb668d330",
            "X-RapidAPI-Host": "deezerdevs-deezer.p.rapidapi.com"
          },
        ),
      );
      if (res.data["error"] != null) {
        if (res.data["error"]["message"] == "Quota limit exceeded") {
          getMusic(name);
        }
      } else {
        musicModel = MusicModel.fromJson(res.data);
        update();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}