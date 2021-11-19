import 'package:academ_gora_release/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/common/notification_service.dart';
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
    NotificationApi.cancelNotification(int.parse(_workout.id!.substring(0,7)));
  }

  void _deleteWorkoutFromInstructor() {
    _firebaseRequestsController.delete(
        "${UserRole.instructor}/${_instructor.id}/Занятия/Занятие ${_workout.id}");
    _firebaseRequestsController.update(
        "${UserRole.instructor}/${_instructor.id}/График работы/${_workout.date}",
        {_workout.from!: "открыто"});
    _firebaseRequestsController.send("Log", {
      DateFormat('yyyy-MM-dd hh-mm-ss').format(DateTime.now()): userCancelledWorkoutForInstructor(_workout.instructorPhoneNumber!),
    });
  }
}
