import 'package:academ_gora_release/screens/profile/user_profile/data/workouts_state_keeper.dart';

abstract class FirebaseWorkoutsController{
  void getWorkoutsAndSubscribeToChanges(WorkoutsDataListener listener);
}