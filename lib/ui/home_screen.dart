import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/ui/tabs/favorite_tab/favorite_tab.dart';
import 'package:evently_app/ui/tabs/home_tab/add_event/add_event_screen.dart';
import 'package:evently_app/ui/tabs/home_tab/home_tab.dart';
import 'package:evently_app/ui/tabs/map_tab/map_tab.dart';
import 'package:evently_app/ui/tabs/profile_tab/profile_tab.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'homeScreen';

  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Widget> tabs = [
    HomeTab(),
    MapTab(),
    FavoriteTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    var eventListProvider = Provider.of<EventListProvider>(context);

    return SafeArea(
      child: Scaffold(
      
        body: tabs[selectedIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: AppColors.transparentColor,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: BottomAppBar(
            padding: EdgeInsets.zero,
            color: Theme.of(context).primaryColor,
            shape: CircularNotchedRectangle(),
            notchMargin: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                selectedLabelStyle: AppStyle.bold14White,
                unselectedLabelStyle: AppStyle.bold14White,
                unselectedItemColor: AppColors.nodeWhiteColor,
                selectedItemColor: AppColors.whiteColor,
                type: BottomNavigationBarType.fixed,
                items: [
                  buildBottomNavItems(
                      index: 0,
                      selectedIconName: AppImage.iconHomeSelected,
                      iconName: AppImage.homeIcon,
                      lable: AppLocalizations.of(context)!.home),
                  buildBottomNavItems(
                      index: 1,
                      selectedIconName: AppImage.iconMapSelected,
                      iconName: AppImage.mapIcon,
                      lable: AppLocalizations.of(context)!.map),
                  buildBottomNavItems(
                      index: 2,
                      selectedIconName: AppImage.iconFavoriteSelected,
                      iconName: AppImage.favoriteIcon,
                      lable: AppLocalizations.of(context)!.favorite),
                  buildBottomNavItems(
                      index: 3,
                      selectedIconName: AppImage.iconProfileSelected,
                      iconName: AppImage.profileIcon,
                      lable: AppLocalizations.of(context)!.profile),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddEventScreen.routeName);
            eventListProvider.changeSelectedIndex(0);
          },
          child: Icon(
            Icons.add,
            color: AppColors.whiteColor,
            size: 30,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavItems(
      {required int index,
      required String iconName,
      required String lable,
      required String selectedIconName}) {
    return BottomNavigationBarItem(
        icon: Image.asset(
          index == selectedIndex ? selectedIconName : iconName,
          width: 24,
          height: 24,
          color: null,
        ),
        label: lable);
  }
}
