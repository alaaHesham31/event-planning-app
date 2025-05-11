import 'package:evently_app/model/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  // data
  MyUser? currentUser;


  //
void updateUser(MyUser newUser){
  currentUser = newUser;
  notifyListeners();
}
}