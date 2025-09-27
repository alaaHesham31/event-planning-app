import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/tabs/home_tab/add_event/add_event_view_model.dart';
import 'package:evently_app/ui/tabs/home_tab/location_picker/location_picker_screen.dart';
import 'package:evently_app/ui/widgets/custom_elevated_button.dart';
import 'package:evently_app/ui/widgets/custom_text_field.dart';
import 'package:evently_app/ui/widgets/tab_event_item.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:evently_app/utils/toast_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'add_event_navigator.dart';

class AddEventScreen extends StatefulWidget {
  static const String routeName = 'addEventScreen';
  final AddEventViewModel? overrideViewModel;

  const AddEventScreen({super.key, this.overrideViewModel});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen>
    implements AddEventNavigator {
  late AddEventViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.overrideViewModel ?? AddEventViewModel();
    viewModel.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    // If a provider is already given above (like in tests), just use it.
    final maybeProvided = context.read<AddEventViewModel?>();
    final effectiveViewModel = maybeProvided ?? viewModel;

    // Always build using the effective viewModel
    return _buildContent(context, effectiveViewModel);
  }

  Widget _buildContent(BuildContext context, AddEventViewModel vm) {
    final eventListProvider = Provider.of<EventListProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final appThemeProvider =
        Provider.of<AppThemeProvider>(context, listen: false);

    // Initialize with providers
    vm.init(eventListProvider, userProvider);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final selectedImage =
        eventListProvider.eventImagesList[eventListProvider.selectedIndex];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.createEvent,
            style: AppStyle.semi20Primary,
          ),
          iconTheme: const IconThemeData(color: AppColors.primaryColor),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.04),
          child: SingleChildScrollView(
            child: Form(
              key: vm.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image
                  Container(
                    height: height * 0.25,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(selectedImage, fit: BoxFit.fill),
                  ),
                  SizedBox(height: height * 0.02),

                  // Category Tabs
                  SizedBox(
                    height: height * 0.07,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          eventListProvider.categoryEventsNameList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            eventListProvider.changeSelectedIndex(
                                index, userProvider.currentUser?.id ?? "");
                          },
                          child: TabEventItem(
                            backgroundSelectedColor: AppColors.primaryColor,
                            borderUnSelectedColor: AppColors.primaryColor,
                            selectedIconColor: appThemeProvider.isLightTheme()
                                ? AppColors.whiteColor
                                : AppColors.navyColor,
                            unSelectedIconColor: AppColors.primaryColor,
                            selectedTextStyle: appThemeProvider.isLightTheme()
                                ? AppStyle.bold14White
                                : AppStyle.bold14Black,
                            unSelectedTextStyle: AppStyle.bold14Primary,
                            isSelected:
                                eventListProvider.selectedIndex == index,
                            eventName:
                                eventListProvider.categoryEventsNameList[index],
                            eventIconPath:
                                eventListProvider.categoryEventsIconList[index],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  // Title
                  Text(AppLocalizations.of(context)!.title),
                  SizedBox(height: height * 0.02),
                  CustomTextField(
                    controller: vm.titleController,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return AppLocalizations.of(context)!
                            .pleaseEnterEventTitle;
                      }
                      return null;
                    },
                    textStyle: appThemeProvider.isLightTheme()
                        ? AppStyle.semi16Grey
                        : AppStyle.semi16White,
                    hintText: AppLocalizations.of(context)!.eventTitle,
                    hintTextStyle: appThemeProvider.isLightTheme()
                        ? AppStyle.semi16Grey
                        : AppStyle.semi16White,
                    borderColor: appThemeProvider.isLightTheme()
                        ? AppColors.greyColor
                        : AppColors.whiteColor,
                    prefixIcon: const Icon(Icons.edit),
                    prefixIconColor: appThemeProvider.isLightTheme()
                        ? AppColors.greyColor
                        : AppColors.whiteColor,
                  ),
                  SizedBox(height: height * 0.02),

                  // Description
                  Text(AppLocalizations.of(context)!.description),
                  SizedBox(height: height * 0.02),
                  CustomTextField(
                    controller: vm.descriptionController,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return AppLocalizations.of(context)!
                            .pleaseEnterEventDescription;
                      }
                      return null;
                    },
                    textStyle: appThemeProvider.isLightTheme()
                        ? AppStyle.semi16Grey
                        : AppStyle.semi16White,
                    maxLines: 4,
                    hintText: AppLocalizations.of(context)!.eventDescription,
                    hintTextStyle: appThemeProvider.isLightTheme()
                        ? AppStyle.semi16Grey
                        : AppStyle.semi16White,
                    borderColor: appThemeProvider.isLightTheme()
                        ? AppColors.greyColor
                        : AppColors.whiteColor,
                  ),
                  SizedBox(height: height * 0.02),

                  // Date
                  Row(
                    children: [
                      Image.asset(
                        AppImage.eventDateIcon,
                        color: appThemeProvider.isLightTheme()
                            ? AppColors.blackColor
                            : AppColors.whiteColor,
                      ),
                      SizedBox(width: width * 0.02),
                      Text(AppLocalizations.of(context)!.eventDate),
                      const Spacer(),
                      InkWell(
                        onTap: () => vm.chooseDate(context),
                        child: Text(
                          vm.selectedDate == null
                              ? AppLocalizations.of(context)!.chooseDate
                              : vm.formattedDate,
                          style: AppStyle.semi16Primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),

                  // Time
                  Row(
                    children: [
                      Image.asset(
                        AppImage.eventTimeIcon,
                        color: appThemeProvider.isLightTheme()
                            ? AppColors.blackColor
                            : AppColors.whiteColor,
                      ),
                      SizedBox(width: width * 0.02),
                      Text(AppLocalizations.of(context)!.eventTime),
                      const Spacer(),
                      InkWell(
                        onTap: () => vm.chooseTime(context),
                        child: Text(
                          vm.selectedTime == null
                              ? AppLocalizations.of(context)!.chooseTime
                              : vm.formattedTime,
                          style: AppStyle.semi16Primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),

                  // Location
                  InkWell(
                    onTap: () => vm.chooseLocation(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: height * 0.012,
                                horizontal: width * 0.025),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.primaryColor,
                            ),
                            child: Icon(
                              Icons.my_location,
                              color: appThemeProvider.isLightTheme()
                                  ? AppColors.whiteColor
                                  : AppColors.navyColor,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Text(
                            vm.selectedLocation ??
                                AppLocalizations.of(context)!
                                    .chooseEventLocation,
                            style: AppStyle.semi16Primary,
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              size: 20, color: AppColors.primaryColor),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  // Submit
                  CustomElevatedButton(
                    onClick: vm.addEvent,
                    textStyle: AppStyle.semi20White,
                    text: AppLocalizations.of(context)!.addEvent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void showToastMsg(String message, Color color) {
    ToastMessage.toastMsg(message, color);
  }

  @override
  Future<LatLng?> pickLocation(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
    );
  }

  @override
  void closeScreen() {
    Navigator.pop(context);
  }
}
