import 'package:academ_gora_release/model/workout.dart';

class WorkoutsKeeper {
  static final WorkoutsKeeper _workoutsKeeper = WorkoutsKeeper._internal();
  late WorkoutsDataListener _listener;

  WorkoutsKeeper._internal();

  factory WorkoutsKeeper() {
    return _workoutsKeeper;
  }

  void saveWorkouts(List<Workout> workouts) {
    _listener.updateListener(workouts);
  }

  void setListener(WorkoutsDataListener listener){
    _listener = listener;
  }
}

abstract class WorkoutsDataListener{
  void updateListener(List<Workout> workouts);
}