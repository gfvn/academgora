import 'package:academ_gora_release/controller/firebase_requests_controller.dart';
import 'package:academ_gora_release/controller/times_controller.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/model/user_role.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:academ_gora_release/screens/account/helpers_widgets/workout_widget/cancel_workout.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CancelWorkoutImplementation implements CancelWorkout {

  final FirebaseRequestsController _firebaseRequestsController = FirebaseRequestsController();
  final TimesController _timesController = TimesController();
  final Instructor _instructor;
  final Workout _workout;

  CancelWorkoutImplementation(this._instructor, this._workout);

  @override
  void cancelWorkout() {
    _deleteWorkoutFromUser();
    _deleteWorkoutFromInstructor();
  }

  void _deleteWorkoutFromUser() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    _firebaseRequestsController
        .delete("${UserRole.user}/$userId/Занятия/${_workout.id}");
  }

  void _deleteWorkoutFromInstructor() {
    _firebaseRequestsController
        .delete(
        "${UserRole.instructor}/${_instructor.id}/Занятия/Занятие ${_workout
            .id}");
    _firebaseRequestsController.update(
        "${UserRole.instructor}/${_instructor.id}/График работы/${_workout
            .date}",
        _timesController.setTimesStatus(_workout.from!,
            _workout.workoutDuration!, "открыто"));
  }
}