import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  final Future<SharedPreferences> userPreferences = SharedPreferences.getInstance();
}
