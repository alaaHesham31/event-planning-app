import 'package:evently_app/providers/app_language_provider.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/tabs/home_tab/event_details/event_details_screen.dart';
import 'package:evently_app/ui/tabs/home_tab/home_navigator.dart';
import 'package:evently_app/ui/tabs/home_tab/home_tab_view_model.dart';
import 'package:evently_app/ui/widgets/event_item_widget.dart';
import 'package:evently_app/ui/widgets/tab_event_item.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:evently_app/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../providers/app_theme_provider.dart';

class HomeTab extends StatefulWidget {
  HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> implements HomeNavigator {
  late UserProvider userProvider;
  late AppThemeProvider appThemeProvider;
  bool _initialized = false;
  late HomeTabViewModel homeTabViewModel;

  @override
  void initState() {
    super.initState();
    homeTabViewModel = HomeTabViewModel();
    homeTabViewModel.navigator = this;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final eventListProvider =
            Provider.of<EventListProvider>(context, listen: false);
        final userProv = Provider.of<UserProvider>(context, listen: false);
        eventListProvider.initCategories(context);
        eventListProvider.updateLanguage(context);
        if (eventListProvider.allEventsList.isEmpty) {
          try {
            await eventListProvider.loadAllEvents(userProv.currentUser!.id);
          } catch (e) {
            debugPrint('loadAllEvents error: $e');
          }
        }
      });

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventListProvider = Provider.of<EventListProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    appThemeProvider = Provider.of<AppThemeProvider>(context);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: buildAppBarContent(width),
        backgroundColor: appThemeProvider.isLightTheme()
            ? AppColors.primaryColor
            : AppColors.navyColor,
      ),
      body: Column(
        children: [
          Container(
            height: height * 0.11,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: appThemeProvider.isLightTheme()
                  ? AppColors.primaryColor
                  : AppColors.navyColor,
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
                    SizedBox(width: width * 0.02),
                    InkWell(
                      onTap: () async {
                        if (userProvider.currentUser!.city == null ||
                            userProvider.currentUser!.city!.isEmpty) {
                          await homeTabViewModel.onLocationClicked(context);
                        } else {
                          final confirm = await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(AppLocalizations.of(context)!
                                  .changeLocationTitle),
                              content: Text(AppLocalizations.of(context)!
                                  .changeLocationContent),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text(AppLocalizations.of(context)!.no),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child:
                                      Text(AppLocalizations.of(context)!.yes),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await homeTabViewModel.onLocationClicked(context);
                          }
                        }
                      },
                      child: Text(
                        (userProvider.currentUser!.city == null ||
                                userProvider.currentUser!.city!.isEmpty)
                            ? "Set your location"
                            : "${userProvider.currentUser!.city}, ${userProvider.currentUser!.country}",
                        style: (userProvider.currentUser!.city == null ||
                                userProvider.currentUser!.city!.isEmpty)
                            ? AppStyle.bold14White.copyWith(
                                decoration: TextDecoration.underline,
                                color: Colors.yellowAccent,
                              )
                            : AppStyle.semi16White,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  height: height * 0.06,
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
                          backgroundSelectedColor:
                              appThemeProvider.isLightTheme()
                                  ? AppColors.whiteColor
                                  : AppColors.primaryColor,
                          borderUnSelectedColor: appThemeProvider.isLightTheme()
                              ? AppColors.whiteColor
                              : AppColors.primaryColor,
                          selectedIconColor: appThemeProvider.isLightTheme()
                              ? AppColors.primaryColor
                              : AppColors.whiteColor,
                          unSelectedIconColor: AppColors.whiteColor,
                          selectedTextStyle: appThemeProvider.isLightTheme()
                              ? AppStyle.bold14Primary
                              : AppStyle.bold14White,
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
    final themeProvider = Provider.of<AppThemeProvider>(context, listen: false);
    final langProvider =
        Provider.of<AppLanguageProvider>(context, listen: false);

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
            // Theme Toggle
            GestureDetector(
              onTap: () {
                themeProvider.changeAppTheme(
                  themeProvider.isLightTheme()
                      ? AppTheme.darkTheme
                      : AppTheme.lightTheme,
                );
              },
              child: Icon(
                themeProvider.isLightTheme()
                    ? Icons.sunny
                    : Icons.nightlight_round,
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(width: width * 0.04),

            // Language Toggle
            GestureDetector(
              onTap: () {
                langProvider.changeAppLanguage(
                  langProvider.appLanguage == 'en' ? 'ar' : 'en',
                );
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Provider.of<EventListProvider>(context, listen: false)
                      .updateLanguage(context);
                });
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  langProvider.appLanguage.toUpperCase(),
                  style: themeProvider.isLightTheme()
                      ? AppStyle.bold14Primary
                      : AppStyle.bold14Black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Future<bool?> showLocationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.changeLocationTitle),
        content: Text(AppLocalizations.of(context)!.changeLocationContent),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.no)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.yes),
          )
        ],
      ),
    );
  }

  @override
  void showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}
