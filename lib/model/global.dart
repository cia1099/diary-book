import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class GlobalVariable /*with ChangeNotifier*/ {
  /**
   * with ChangeNotifier which have not belong null varialble
   */
  GlobalVariable({DateTime? selectedTime}) : _selectedTime = selectedTime;
  DateTime? _selectedTime;
  bool _isDescend = true;

  DateTime? get selectedTime => _selectedTime;
  // ignore: unnecessary_getters_setters
  set selectedTime(DateTime? time) {
    _selectedTime = time;
    // notifyListeners();
  }

  bool get isDescend => _isDescend;
  // ignore: unnecessary_getters_setters
  set isDescend(bool val) {
    _isDescend = val;
    // notifyListeners();
  }
}
