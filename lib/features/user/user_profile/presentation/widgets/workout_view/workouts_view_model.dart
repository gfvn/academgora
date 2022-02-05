
import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/workout.dart';

abstract class WorkoutsViewModel{
  Stream<List<Workout>> get workoutsList;
  void getWorkouts();
}