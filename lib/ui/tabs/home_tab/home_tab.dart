import 'package:evently_app/ui/widgets/event_item_widget.dart';
import 'package:evently_app/ui/widgets/tab_event_item.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeTab extends StatefulWidget {
  HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<String> eventsNameList = [
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.sport,
      AppLocalizations.of(context)!.birthday,
      AppLocalizations.of(context)!.gaming,
      AppLocalizations.of(context)!.eating,
      AppLocalizations.of(context)!.holiday,
      AppLocalizations.of(context)!.bookClub,
      AppLocalizations.of(context)!.workShop,
      AppLocalizations.of(context)!.exhibition,
    ];
    List<String> eventIconsList = [
      AppImage.all,
      AppImage.sport,
      AppImage.birthday,
      AppImage.gaming,
      AppImage.eating,
      AppImage.holiday,
      AppImage.bookClub,
      AppImage.workShop,
      AppImage.exhibition
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: buildAppBarContent(width),
      ),
      body: Column(
        children: [
          Container(
            height: height * 0.11,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      AppImage.mapIcon,
                      height: 20,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      'Cairo , Egypt',
                      style: AppStyle.semi16White,
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: eventsNameList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          selectedIndex = index;
                          setState(() {});
                        },
                        child: TabEventItem(
                          backgroundSelectedColor: AppColors.whiteColor,
                          borderUnSelectedColor: AppColors.whiteColor,
                          selectedIconColor: AppColors.primaryColor,
                          unSelectedIconColor: AppColors.whiteColor,
                          selectedTextStyle: AppStyle.bold14Primary,
                          unSelectedTextStyle: AppStyle.bold14White,
                          isSelected: selectedIndex == index,
                          eventName: eventsNameList[index],
                          eventIconPath: eventIconsList[index],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                  itemCount: 10,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: height * 0.02,
                    );
                  },
                  itemBuilder: (context, index) {
                    return EventItemWidget();
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBarContent(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.welcomeBack,
              style: AppStyle.regular16White,
            ),
            Text(
              'Alaa',
              style: AppStyle.bold24White,
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.sunny,
              color: AppColors.whiteColor,
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'EN',
                style: AppStyle.bold14Primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
