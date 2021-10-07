import 'package:academ_gora_release/model/workout.dart';
import 'package:academ_gora_release/screens/account/user_profile/data/workouts_state_keeper.dart';

abstract class FirebaseWorkoutsController{
  void getWorkoutsAndSubscribeToChanges(WorkoutsDataListener listener);
}