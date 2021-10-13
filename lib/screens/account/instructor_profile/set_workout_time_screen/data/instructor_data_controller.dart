import 'package:academ_gora_release/screens/account/instructor_profile/set_workout_time_screen/data/instructor_state_keeper.dart';

abstract class InstructorDataController{
  void getInstructorData(InstructorDataListener listener);
}