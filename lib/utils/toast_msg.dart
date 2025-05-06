import 'package:evently_app/utils/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage{
  static Future<bool?>  toastMsg(String message){
    return   Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.greyColor,
        textColor: AppColors.whiteColor,
        fontSize: 16.0
    );

  }
}