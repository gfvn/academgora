
import 'package:academ_gora_release/features/user/user_profile/data/workouts_state_keeper.dart';

abstract class FirebaseWorkoutsController{
  void getWorkoutsAndSubscribeToChanges(WorkoutsDataListener listener);
}