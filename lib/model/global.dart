import 'package:flutter/foundation.dart';

class GlobalVariable with ChangeNotifier {
  GlobalVariable({DateTime? selectedTime}) : _selectedTime = selectedTime;
  DateTime? _selectedTime;
  bool _isDescend = true;

  DateTime? get selectedTime => _selectedTime;
  // ignore: unnecessary_getters_setters
  set selectedTime(DateTime? time) {
    _selectedTime = time;
    notifyListeners();
  }

  bool get isDescend => _isDescend;
  // ignore: unnecessary_getters_setters
  set isDescend(bool val) {
    _isDescend = val;
    notifyListeners();
  }
}
