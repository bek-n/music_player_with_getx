import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:music_player_with_getx/presentation/components/zoom_tab_animation.dart';
import 'package:music_player_with_getx/presentation/styles/style.dart';

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
  double initValue = 1.0;
  List<double> value = [1.0, 2.0, 3.0];

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
        backgroundColor: Style.darkBgcolorOfApp,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Style.whiteColor),
          backgroundColor: Style.darkBgcolorOfApp,
        ),
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
                        controllerSearch
                                .musicModel
                                .data?[controller.selectIndex.value]
                                .artist
                                ?.name ??
                            "",
                        style: Style.textStyleRegular(
                            textColor: Style.whiteColor, size: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                        controllerSearch.musicModel
                                .data?[controller.selectIndex.value].title ??
                            "",
                        style: Style.textStyleRegular(
                            textColor: Style.whiteColor)),
                  ),
                  StreamBuilder(
                      stream: controller.player.positionStream,
                      builder: (context, s) {
                        if (controller.selectIndex.value <
                                (controllerSearch.musicModel.data?.length ??
                                    0) &&
                            s.data == controller.player.duration &&
                            s.hasData) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            controller.selectIndex.value++;
                          });
                            }
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Slider(
                                  thumbColor: Style.primaryColor,
                                  activeColor: Style.primaryColor,
                                  inactiveColor: Style.greyColor90,
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
                                  child: Text(s.data.toString().substring(0, 7),
                                      style: Style.textStyleRegular(
                                          textColor: Style.whiteColor)),
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
                                        color: Style.whiteColor,
                                      )),
                                  ZoomTabAnimation(
                                    child: Container(
                                      height: 80.h,
                                      width: 80.w,
                                      decoration: const BoxDecoration(
                                          color: Style.primaryColor,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: IconButton(
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
                                            color: Style.blackColor,
                                          ),
                                        ),
                                      ),
                                    ),
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
                                        color: Style.whiteColor,
                                      ))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Row(
                                  children: [
                                    // const Icon(
                                    //   Icons.volume_mute,
                                    //   size: 28,
                                    //   color: Style.whiteColor,
                                    // ),
                                    // Slider(
                                    //   min: 0,
                                    //   max: 1,
                                    //   value: controller.player.volume,
                                    //   onChanged: (value) {
                                    //     controller.player.setVolume(value);
                                    //     controller.update();
                                    //   },
                                    // ),
                                    // const Icon(
                                    //   Icons.volume_up,
                                    //   size: 28,
                                    //   color: Style.whiteColor,
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: DropdownButton(
                                        value: controller.player.speed,
                                        // Step 4.
                                        items: <double>[1.0, 2.0, 3.0]
                                            .map<DropdownMenuItem<double>>(
                                                (double value) {
                                          return DropdownMenuItem<double>(
                                            value: value,
                                            child: Text(
                                              value.toString(),
                                              style: Style.textStyleRegular2(
                                                  textColor:
                                                      Style.primaryColor),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (s) {
                                          if (s != null) {
                                            initValue = s;
                                            controller.setSpeed(s);
                                            controller.update();
                                          }
                                        },
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
