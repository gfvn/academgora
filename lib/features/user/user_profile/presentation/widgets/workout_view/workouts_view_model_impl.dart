import 'dart:async';

import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/workout.dart';
import 'package:academ_gora_release/features/user/user_profile/data/firebase_workouts_controller.dart';
import 'package:academ_gora_release/features/user/user_profile/data/firebase_workouts_controller_impl.dart';
import 'package:academ_gora_release/features/user/user_profile/data/workouts_state_keeper.dart';
import 'package:academ_gora_release/features/user/user_profile/presentation/widgets/workout_view/workouts_view_model.dart';

class WorkoutsViewModelImpl implements WorkoutsViewModel, WorkoutsDataListener{

  final FirebaseWorkoutsController _controller = FirebaseWorkoutsControllerImplementation();
  final _workoutsListController = StreamController<List<Workout>>.broadcast();

  @override
   void getWorkouts(){
     _controller.getWorkoutsAndSubscribeToChanges(this);
   }

  @override
  Stream<List<Workout>> get workoutsList => _workoutsListController.stream;

  @override
  void updateListener(List<Workout> workouts) {
    _workoutsListController.sink.add(workouts);
  }

  void dispose() {
    _workoutsListController.close();
  }

}