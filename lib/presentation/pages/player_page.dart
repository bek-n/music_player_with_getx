import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../application/player_controller.dart';
import '../../application/search_controller.dart';


class AudioPlayerPage extends StatefulWidget {
  final int selectIndex;

  const AudioPlayerPage({Key? key, required this.selectIndex})
      : super(key: key);

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final controller = Get.put(PlayerController());
  final controllerSearch = Get.put(SearchController());

  @override
  void initState() {
    controller.getMusics(
        model: controllerSearch.musicModel, index: widget.selectIndex);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Obx(() => Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Container(
                    height: 350,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                          image: NetworkImage(
                            controllerSearch
                                    .musicModel
                                    .data?[controller.selectIndex.value]
                                    .album
                                    ?.coverBig ??
                                "",
                          ),
                          fit: BoxFit.cover),
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      controllerSearch.musicModel
                              .data?[controller.selectIndex.value].title ??
                          "",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  StreamBuilder(
                      stream: controller.player.positionStream,
                      builder: (context, s) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Slider(
                                min: 0,
                                max: controller.player.duration?.inSeconds
                                        .toDouble() ??
                                    1,
                                value: (s.data?.inSeconds.toDouble() ?? 1),
                                onChanged: (value) {
                                  controller.player
                                      .seek(Duration(seconds: value.toInt()));
                                },
                                onChangeStart: (a) {
                                  controller.pause();
                                },
                                onChangeEnd: (b) {
                                  controller.play();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  s.data.toString().substring(0, 7),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GetBuilder<PlayerController>(builder: (context) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (controller.selectIndex.value > 0) {
                                          controller.player.seekToPrevious();
                                          controller.selectIndex.value--;
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.skip_previous_rounded,
                                        size: 60,
                                      )),
                                  IconButton(
                                    onPressed: () {
                                      !controller.isPlaying
                                          ? controller.play()
                                          : controller.pause();
                                    },
                                    icon: Icon(
                                      controller.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      size: 60,
                                    ),
                                    iconSize: 32,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (controller.selectIndex.value <
                                            (controllerSearch
                                                    .musicModel.data?.length ??
                                                0)) {
                                          controller.player.seekToNext();
                                          controller.selectIndex.value++;
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.skip_next_rounded,
                                        size: 60,
                                      ))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.volume_mute,
                                      size: 28,
                                    ),
                                    Slider(
                                      min: 0,
                                      max: 1,
                                      value: controller.player.volume,
                                      onChanged: (value) {
                                        controller.player.setVolume(value);
                                        controller.update();
                                      },
                                    ),
                                    const Icon(
                                      Icons.volume_up,
                                      size: 28,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: DropdownButton(
                                        items: const [
                                          DropdownMenuItem(
                                            value: 1.0,
                                            child: Text(
                                              "1x",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 2.0,
                                            child: Text("2x",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                          DropdownMenuItem(
                                            value: 3.0,
                                            child: Text("3x",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          )
                                        ],
                                        onChanged: (s) {
                                          if (s != null) {
                                            controller.setSpeed(s);
                                          }
                                        },
                                        value: controller.player.speed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            )));
  }
}
