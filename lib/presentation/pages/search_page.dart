import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_with_getx/presentation/components/custom_textfromfiled.dart';
import 'package:music_player_with_getx/presentation/components/zoom_tab_animation.dart';
import 'package:music_player_with_getx/presentation/pages/player_page.dart';
import 'package:music_player_with_getx/presentation/styles/style.dart';
import '../../application/search_controller.dart';
import '../components/timer_search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController textController = TextEditingController();
  final controller = Get.put(SearchController());
  final _delayed = Delayed(milliseconds: 700);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.darkBgcolorOfApp,
      appBar: AppBar(
        title: Text(
          'Search and Listen',
          style: Style.textStyleRegular(textColor: Style.whiteColor, size: 25),
        ),
        backgroundColor: Style.darkBgcolorOfApp,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            CustomTextFrom(
              style: Style.textStyleRegular(textColor: Style.whiteColor),
              hintext: '',
              label: "",
              suffixicon: Icon(
                Icons.search,
                color: Style.whiteColor,
              ),
              isObscure: false,
              onChange: (value) {
                _delayed.run(() async {
                  controller.getMusic(textController.text);
                  setState(() {});
                });
              },
            ),
            GetBuilder<SearchController>(builder: (context) {
              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: controller.musicModel.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(() => AudioPlayerPage(
                                selectIndex: index,
                              ));
                        },
                        child: ZoomTabAnimation(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Image.network(
                                  controller.musicModel.data?[index].album
                                          ?.coverMedium ??
                                      "",
                                  width: 64,
                                ),
                                Expanded(
                                  child: Text(
                                    controller.musicModel.data?[index].title ??
                                        "",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
            })
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     controller.getMusic(textController.text);
      //   },
      // ),
    );
  }
}
