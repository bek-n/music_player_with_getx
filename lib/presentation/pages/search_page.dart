import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_with_getx/presentation/pages/player_page.dart';
import '../../application/search_controller.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController textController = TextEditingController();
  final controller = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: textController,
              decoration: InputDecoration(labelText: "Search"),
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
                        child: Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.all(8),
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
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.getMusic(textController.text);
        },
      ),
    );
  }
}