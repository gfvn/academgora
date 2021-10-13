import 'package:academ_gora_release/screens/account/user_profile/data/workouts_state_keeper.dart';

abstract class FirebaseWorkoutsController{
  void getWorkoutsAndSubscribeToChanges(WorkoutsDataListener listener);
}