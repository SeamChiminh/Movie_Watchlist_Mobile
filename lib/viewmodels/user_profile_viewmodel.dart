import 'package:flutter/foundation.dart';

class UserProfileViewModel extends ChangeNotifier {
  String name = 'Seam Chiminh';
  String email = 'seamchiminh@gmail.com';
  String phone = '012 345 678';
  String? profileImagePath;

  void updateProfile({
    String? name,
    String? email,
    String? phone,
  }) {
    if (name != null) this.name = name;
    if (email != null) this.email = email;
    if (phone != null) this.phone = phone;
    notifyListeners();
  }

  void setProfileImagePath(String? path) {
    profileImagePath = path;
    notifyListeners();
  }
}
