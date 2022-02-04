import 'package:academ_gora_release/model/workout.dart';

class UserWorkoutsKeeper {
  static final UserWorkoutsKeeper _userDataKeeper = UserWorkoutsKeeper._internal();
  List<Workout> _workoutsList = [];

  UserWorkoutsKeeper._internal();

  factory UserWorkoutsKeeper() {
    return _userDataKeeper;
  }

  void updateWorkouts(Map? workouts) {
    _workoutsList = [];
    if (workouts != null) {
      workouts.forEach((key, value) {
        _workoutsList.add(Workout.fromJson(key, value));
      });
    }
  }

  List<Workout> get workoutsList => _workoutsList;
}
