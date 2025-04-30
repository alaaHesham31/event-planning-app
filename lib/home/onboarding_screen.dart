import 'package:evently_app/home/home_screen.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = 'onboardingScreen';
   OnboardingScreen({super.key});

  List<PageViewModel> listPagesViewModel =[
    PageViewModel(
      title: "Effortless Event Planning",
      body: "Take the hassle out of organizing events with our all-in-one planning tools. From setting up invites and managing RSVPs to scheduling reminders and coordinating details, we’ve got you covered. Plan with ease and focus on what matters – creating an unforgettable experience for you and your guests.",
      image:  Center(
        child:Image.asset(AppImage.onBoarding1) ,
      ),
      decoration:  PageDecoration(
        titleTextStyle: AppStyle.bold20Primary,
        bodyTextStyle:AppStyle.semi16Black,
      ),
    ),
    PageViewModel(
      title: "Find Events That Inspire You",
      body: "Dive into a world of events crafted to fit your unique interests. Whether you're into live music, art workshops, professional networking, or simply discovering new experiences, we have something for everyone. Our curated recommendations will help you explore, connect, and make the most of every opportunity around you.",
      image:  Center(
        child:Image.asset(AppImage.onBoarding2) ,
      ),
      decoration:  PageDecoration(
        titleTextStyle: AppStyle.bold20Primary,
        bodyTextStyle:AppStyle.semi16Black,
      ),
    ),
    PageViewModel(
      title: "Connect with Friends & Share Moments",
      body: "Make every event memorable by sharing the experience with others. Our platform lets you invite friends, keep everyone in the loop, and celebrate moments together. Capture and share the excitement with your network, so you can relive the highlights and cherish the memories.",
      image:  Center(
        child:Image.asset(AppImage.onBoarding3) ,
      ),
      decoration:  PageDecoration(
        titleTextStyle: AppStyle.bold20Primary,
        bodyTextStyle:AppStyle.semi16Black,
      ),
    ),



  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.nodeWhiteColor,
        centerTitle: true,
        title: Image(image: AssetImage(AppImage.eventlyHeader)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: IntroductionScreen(
                pages: listPagesViewModel,
                showSkipButton: false,
                showBackButton: true,
                back: builtArrowContainer(Icons.arrow_back),
                next:builtArrowContainer(Icons.arrow_forward),

                done: builtArrowContainer(Icons.arrow_forward),
                onDone: () {
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                },

                dotsDecorator: DotsDecorator(
                  size: const Size.square(10.0),
                  activeSize: const Size(30.0, 10.0),
                  activeColor: AppColors.primaryColor,
                  color: AppColors.blackColor,
                  spacing: const EdgeInsets.symmetric(horizontal: 2.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Widget builtArrowContainer(IconData iconName){
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
            color: AppColors.primaryColor
        ),
      ),
      child: Icon(iconName, color: AppColors.primaryColor, size: 28,),
    );
    
  }
}
