import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/tabs/home_tab/edit_event/edit_event_viewmodel.dart';
import 'package:evently_app/ui/tabs/home_tab/location_picker/location_picker_screen.dart';
import 'package:evently_app/ui/widgets/custom_elevated_button.dart';
import 'package:evently_app/ui/widgets/custom_text_field.dart';
import 'package:evently_app/ui/widgets/tab_event_item.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class EditEventScreen extends StatelessWidget {
  static const String routeName = 'edit-details-screen';

  const EditEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EventModel;
    final appThemeProvider =
        Provider.of<AppThemeProvider>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => EditEventViewModel(
        eventListProvider:
            Provider.of<EventListProvider>(context, listen: false),
        userProvider: Provider.of<UserProvider>(context, listen: false),
      )..init(args),
      child: Consumer<EditEventViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.editEvent,
                style: AppStyle.semi20Primary,
              ),
              iconTheme: const IconThemeData(color: AppColors.primaryColor),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        viewModel.selectedImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel
                            .eventListProvider.categoryEventsNameList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              viewModel.eventListProvider.changeSelectedIndex(
                                index,
                                viewModel.userProvider.currentUser!.id,
                              );
                              viewModel.selectedImage = viewModel
                                  .eventListProvider.eventImagesList[index];
                              viewModel.selectedEvent = viewModel
                                  .eventListProvider
                                  .categoryEventsNameList[index];
                              viewModel.notifyListeners();
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
                                  viewModel.eventListProvider.selectedIndex ==
                                      index,
                              eventName: viewModel.eventListProvider
                                  .categoryEventsNameList[index],
                              eventIconPath: viewModel.eventListProvider
                                  .categoryEventsIconList[index],
                            ),
                          );
                        },
                      ),
                    ),
                    Form(
                      key: viewModel.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(AppLocalizations.of(context)!.title,
                              style: AppStyle.semi16Black),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: viewModel.titleController,
                            validator: (text) => (text == null || text.isEmpty)
                                ? 'Please Enter Event Title'
                                : null,
                            hintText: AppLocalizations.of(context)!.eventTitle,
                            textStyle: appThemeProvider.isLightTheme()
                                ? AppStyle.semi16Grey
                                : AppStyle.semi16White,
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
                          const SizedBox(height: 16),
                          Text(AppLocalizations.of(context)!.description,
                              style: AppStyle.semi16Black),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: viewModel.descriptionController,
                            validator: (text) => (text == null || text.isEmpty)
                                ? 'Please Enter Event Description'
                                : null,
                            maxLines: 4,
                            hintText:
                                AppLocalizations.of(context)!.eventDescription,
                            textStyle: appThemeProvider.isLightTheme()
                                ? AppStyle.semi16Grey
                                : AppStyle.semi16White,
                            hintTextStyle: appThemeProvider.isLightTheme()
                                ? AppStyle.semi16Grey
                                : AppStyle.semi16White,
                            borderColor: appThemeProvider.isLightTheme()
                                ? AppColors.greyColor
                                : AppColors.whiteColor,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Image.asset(AppImage.eventDateIcon,
                                  color: appThemeProvider.isLightTheme()
                                      ? AppColors.blackColor
                                      : AppColors.whiteColor),
                              const SizedBox(width: 12),
                              Text(AppLocalizations.of(context)!.eventDate,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              const Spacer(),
                              InkWell(
                                onTap: () => viewModel.chooseDate(context),
                                child: Text(
                                  viewModel.formattedDate ??
                                      AppLocalizations.of(context)!.chooseDate,
                                  style: AppStyle.semi16Primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Image.asset(AppImage.eventTimeIcon,
                                  color: appThemeProvider.isLightTheme()
                                      ? AppColors.blackColor
                                      : AppColors.whiteColor),
                              const SizedBox(width: 12),
                              Text(AppLocalizations.of(context)!.eventTime,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              const Spacer(),
                              InkWell(
                                onTap: () => viewModel.chooseTime(context),
                                child: Text(
                                  viewModel.formattedTime ??
                                      AppLocalizations.of(context)!.chooseTime,
                                  style: AppStyle.semi16Primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(AppLocalizations.of(context)!.location,
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () async {
                              final pickedLocation =
                                  await Navigator.of(context).pushNamed(
                                LocationPickerScreen.routeName,
                              );
                              if (pickedLocation != null &&
                                  pickedLocation is LatLng) {
                                await viewModel.pickLocation(pickedLocation);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: AppColors.primaryColor),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
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
                                  const SizedBox(width: 12),
                                  Text(
                                    '${viewModel.selectedCity} , ${viewModel.selectedCountry}',
                                    style: AppStyle.semi16Primary,
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios_rounded,
                                      color: AppColors.primaryColor, size: 20),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomElevatedButton(
                            onClick: () => viewModel.updateEvent(context),
                            textStyle: AppStyle.semi20White,
                            text: AppLocalizations.of(context)!.updateEvent,
                          ),
                          const SizedBox(height: 22),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
