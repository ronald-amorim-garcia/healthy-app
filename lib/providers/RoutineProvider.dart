import 'package:healthy_app/commons.dart';

class RoutineProvider extends ChangeNotifier{
  bool _college = false;
  double _daysPerWeekCollege = 1;

  bool _work = false;
  double _daysPerWeekWork = 1;

  bool _physicalActivity = false;
  double _daysPerWeekActivity = 1;

  // Getters
  bool get college => _college;
  double get daysPerWeekCollege => _daysPerWeekCollege;

  bool get work => _work;
  double get daysPerWeekWork => _daysPerWeekWork;

  bool get physicalActivity => _physicalActivity;
  double get daysPerWeekActivity => _daysPerWeekActivity;

  // Setters (update + notify listeners)
  void setCollege(bool value) {
    _college = value;
    notifyListeners();
  }

  void setDaysPerWeekCollege(double value) {
    _daysPerWeekCollege = value;
    notifyListeners();
  }

  void setWork(bool value) {
    _work = value;
    notifyListeners();
  }

  void setDaysPerWeekWork(double value) {
    _daysPerWeekWork = value;
    notifyListeners();
  }

  void setPhysicalActivity(bool value) {
    _physicalActivity = value;
    notifyListeners();
  }

  void setDaysPerWeekActivity(double value) {
    _daysPerWeekActivity = value;
    notifyListeners();
  }
}