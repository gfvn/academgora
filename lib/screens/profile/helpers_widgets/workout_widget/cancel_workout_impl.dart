import 'package:academ_gora_release/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/model/user_role.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:academ_gora_release/screens/extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'cancel_workout.dart';

class CancelWorkoutImplementation implements CancelWorkout {
  final FirebaseRequestsController _firebaseRequestsController =
      FirebaseRequestsController();
  final Instructor _instructor;

  CancelWorkoutImplementation(this._instructor);

  @override
  void cancelWorkout(Workout workout) {
    _deleteWorkoutFromUser(workout);
    _deleteWorkoutFromInstructor(workout);
    _createCancelOnDB(workout);
  }

  void _createCancelOnDB(Workout workout) {
    _firebaseRequestsController.update(
      "Отмена/${workout.id.toString()}",
      {
        "workout_id": workout.id,
        "workout_sportType": workout.sportType,
        "date": workout.date,
        "time": (workout.from.toString() + "-" + workout.to.toString()),
        "instructor_name": workout.instructorName,
        "instructor_fcm_token": workout.instructorFcmToken,
        "instructor_phone": workout.instructorPhoneNumber,
        "duration": workout.workoutDuration,
        "user_number": workout.userPhoneNumber
      },
    );
  }

  void _deleteWorkoutFromUser(Workout workout) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    _firebaseRequestsController
        .delete("${UserRole.user}/$userId/Занятия/${workout.id}");
  }

  void _deleteWorkoutFromInstructor(Workout workout) {
    _firebaseRequestsController.delete(
        "${UserRole.instructor}/${_instructor.id}/Занятия/Занятие ${workout.id}");
    _firebaseRequestsController.update(
        "${UserRole.instructor}/${_instructor.id}/График работы/${workout.date}",
        {workout.from!: "открыто"});
    _firebaseRequestsController.update(
      "Log/Users",
      {
        DateFormat('yyyy-MM-dd hh-mm-ss').format(DateTime.now()):
            userCancekWorkout(
          _instructor.phone ?? '',
        )
      },
    );
  }
}
