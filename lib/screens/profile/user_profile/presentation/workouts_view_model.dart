import 'package:academ_gora_release/model/workout.dart';

abstract class WorkoutsViewModel{
  Stream<List<Workout>> get workoutsList;
  void getWorkouts();
}