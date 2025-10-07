import 'package:flutter/material.dart';

class RoutineProvider extends ChangeNotifier {
  // Activities
  bool _college = false;
  double _daysPerWeekCollege = 1;

  bool _work = false;
  double _daysPerWeekWork = 1;

  bool _physicalActivity = false;
  double _daysPerWeekActivity = 1;

  int _mainMealsPerDay = 3;
  LunchOption _eatingHabits = LunchOption.none;

  // Getters
  bool get college => _college;
  double get daysPerWeekCollege => _daysPerWeekCollege;

  bool get work => _work;
  double get daysPerWeekWork => _daysPerWeekWork;

  bool get physicalActivity => _physicalActivity;
  double get daysPerWeekActivity => _daysPerWeekActivity;

  int get mainMealsPerDay => _mainMealsPerDay;
  LunchOption get eatingHabits => _eatingHabits;

  // Setters with notifyListeners
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

  void setMainMealsPerDay(int value) {
    _mainMealsPerDay = value;
    notifyListeners();
  }

  void setEatingHabits(LunchOption value) {
    _eatingHabits = value;
    notifyListeners();
  }
}

enum LunchOption {delivery, dineIn, home, none}
