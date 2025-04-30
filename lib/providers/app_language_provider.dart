import 'package:flutter/material.dart';

class AppLanguageProvider extends ChangeNotifier{
  //data
  String appLanguage = 'en';

  void changeAppLanguage(String newLanguage){
   if( appLanguage == newLanguage){
     return;
   }
   appLanguage = newLanguage;
   notifyListeners();


  }
}