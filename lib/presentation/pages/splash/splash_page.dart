import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:music_player_with_getx/presentation/pages/search_page.dart';
import 'package:music_player_with_getx/presentation/styles/style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => const SearchPage());
     
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Style.darkBgcolorOfApp,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 80,
                width: 80,
              ),
              16.horizontalSpace,
              Text(
                'Hearme',
                style: Style.textStyleRegular(
                    textColor: Style.whiteColor, size: 50),
              )
            ],
          ),
          100.verticalSpace,
          LoadingAnimationWidget.hexagonDots(
              color: Style.primaryColor, size: 60)
        ],
      ),
    );
    ;
  }
}
