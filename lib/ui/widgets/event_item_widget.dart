import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:evently_app/utils/toast_msg.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventItemWidget extends StatelessWidget {
  Event event;

  EventItemWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    var eventListProvider = Provider.of<EventListProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor, width: 1),
        image: DecorationImage(
          image: AssetImage(event.image),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.004, horizontal: width * 0.01),
            margin: EdgeInsets.symmetric(
                vertical: height * 0.01, horizontal: width * 0.02),
            decoration: BoxDecoration(
              color: AppColors.nodeWhiteColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  '${event.eventDate.day}',
                  style: AppStyle.bold20Primary,
                ),
                Text(DateFormat('MMM').format(event.eventDate),
                    style: AppStyle.bold20Primary),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            margin: EdgeInsets.symmetric(
                vertical: height * 0.01, horizontal: width * 0.02),
            decoration: BoxDecoration(
              color: AppColors.nodeWhiteColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  event.title,
                  style: AppStyle.bold16Black,
                ),
                IconButton(
                  onPressed: () {
                    // update favourite
                    var userProvider = Provider.of<UserProvider>(context, listen: false);

                    eventListProvider.updateIsFavouriteEvent(event, userProvider.currentUser!.id);
                    ToastMessage.toastMsg(AppLocalizations.of(context)!.eventUpdatedSuccessfully);
                  },
                  icon: Icon(
                    event.isFavourite == true
                        ? Icons.favorite
                        : Icons.favorite_border_rounded,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
