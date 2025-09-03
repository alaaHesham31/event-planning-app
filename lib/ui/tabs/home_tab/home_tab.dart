import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/tabs/home_tab/event_details_screen.dart';
import 'package:evently_app/ui/widgets/event_item_widget.dart';
import 'package:evently_app/ui/widgets/tab_event_item.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    var eventListProvider = Provider.of<EventListProvider>(context);
    userProvider = Provider.of<UserProvider>(context);

    if (eventListProvider.allEventsList.isEmpty) {
      eventListProvider.loadEventCategories(context);
      eventListProvider.loadAllEvents(userProvider.currentUser!.id);
    }

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

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
                    itemCount: eventListProvider.fullEventsNameList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          eventListProvider.changeSelectedIndex(
                              index, userProvider.currentUser!.id);
                        },
                        child: TabEventItem(
                          backgroundSelectedColor: AppColors.whiteColor,
                          borderUnSelectedColor: AppColors.whiteColor,
                          selectedIconColor: AppColors.primaryColor,
                          unSelectedIconColor: AppColors.whiteColor,
                          selectedTextStyle: AppStyle.bold14Primary,
                          unSelectedTextStyle: AppStyle.bold14White,
                          isSelected: eventListProvider.selectedIndex == index,
                          eventName:
                              eventListProvider.fullEventsNameList[index],
                          eventIconPath:
                              eventListProvider.fullEventsIconList[index],
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
            child: eventListProvider.filteredEventsList.isEmpty
                ? Center(
                    child: Text(AppLocalizations.of(context)!.noEventAddedYet),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: height * 0.02,
                        );
                      },
                      itemCount: eventListProvider.filteredEventsList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                EventDetailsScreen.routeName,
                                arguments: eventListProvider
                                    .filteredEventsList[index]);
                          },
                          child: EventItemWidget(
                              event:
                                  eventListProvider.filteredEventsList[index]),
                        );
                      },
                    ),
                  ),
          ),
          SizedBox(
            height: height * 0.02,
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
              userProvider.currentUser!.name,
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
