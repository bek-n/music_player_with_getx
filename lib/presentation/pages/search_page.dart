import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
  String val = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              suffixicon: const Icon(
                Icons.search,
                color: Style.whiteColor,
              ),
              isObscure: false,
              onChange: (value) {
                _delayed.run(() async {
                  val = value;
                  controller.getMusic(value);
                  setState(() {});
                });
              },
            ),
            val == ''
                ? Center(
                    child: Column(
                    children: [
                      20.verticalSpace,
                      LottieBuilder.asset('assets/images/search.json'),
                      10.verticalSpace,
                      Text(
                        'Search your favourite music',
                        style: Style.textStyleRegular(
                            textColor: Style.whiteColor, size: 25),
                      )
                    ],
                  ))
                : GetBuilder<SearchController>(builder: (context) {
                    return Expanded(
                      child: AnimationLimiter(
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: controller.musicModel.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: ScaleAnimation(
                                  child: SlideAnimation(
                                    child: InkWell(
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
                                                controller
                                                        .musicModel
                                                        .data?[index]
                                                        .album
                                                        ?.coverMedium ??
                                                    "",
                                                width: 64,
                                              ),
                                              25.horizontalSpace,
                                              Expanded(
                                                child: Text(
                                                  controller.musicModel
                                                          .data?[index].title ??
                                                      "",
                                                  style: Style.textStyleRegular(
                                                      textColor:
                                                          Style.whiteColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
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
