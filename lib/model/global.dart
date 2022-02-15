import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class GlobalVariable /*with ChangeNotifier*/ {
  /**
   * with ChangeNotifier which have not belong null varialble
   */
  GlobalVariable({DateTime? selectedTime}) : _selectedTime = selectedTime;
  DateTime? _selectedTime;

  DateTime? get selectedTime => _selectedTime;
  // ignore: unnecessary_getters_setters
  set selectedTime(DateTime? time) {
    _selectedTime = time;
    // notifyListeners();
  }
}
