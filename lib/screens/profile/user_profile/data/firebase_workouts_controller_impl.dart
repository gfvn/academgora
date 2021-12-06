import 'dart:developer';

import 'package:academ_gora_release/common/times_controller.dart';
import 'package:academ_gora_release/model/user_role.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:academ_gora_release/screens/profile/user_profile/data/workouts_state_keeper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_workouts_controller.dart';

class FirebaseWorkoutsControllerImplementation
    implements FirebaseWorkoutsController {
  final String _path =
      "${UserRole.user}/${FirebaseAuth.instance.currentUser!.uid}/Занятия";

  final WorkoutsKeeper _workoutsKeeper = WorkoutsKeeper();

  @override
  void getWorkoutsAndSubscribeToChanges(WorkoutsDataListener listener) async {
    _workoutsKeeper.setListener(listener);
    List<Workout> workouts = await _getWorkoutsFromFirebase();
    _workoutsKeeper.saveWorkouts(workouts);
    _subscribeToServerChanges();
  }

  Future<List<Workout>> _getWorkoutsFromFirebase() async {
    List<Workout> workouts = _parseFirebaseResponseToWorkoutsList(
        await _getWorkoutsFromFirebaseForCurrentUser());
    List<Workout> oldWorkouts = _getOldWorkouts(workouts);
    log("olllld $oldWorkouts");
    if (oldWorkouts.isNotEmpty) oldWorkouts.forEach(workouts.remove);
    _deleteOldWorkoutsFromFirebase(oldWorkouts);
    return _sortWorkouts(workouts);
  }

  Future<Map> _getWorkoutsFromFirebaseForCurrentUser() async {
    DataSnapshot dataSnapshot =
        await FirebaseDatabase.instance.reference().child(_path).once();
    return dataSnapshot.value == null
        ? {}
        : dataSnapshot.value as Map<dynamic, dynamic>;
  }

  List<Workout> _parseFirebaseResponseToWorkoutsList(Map? workouts) {
    List<Workout> _workoutsList = [];
    if (workouts != null) {
      workouts.forEach((key, value) {
        _workoutsList.add(Workout.fromJson(key, value));
      });
    }

    return _workoutsList;
  }

  void _saveWorkoutsAfterSubscriptionDataChanged(Event event) async {
    _saveWorkoutsToKeeper(_parseFirebaseResponseToWorkoutsList(
        await _getWorkoutsFromFirebaseForCurrentUser()));
  }

  void _saveWorkoutsToKeeper(List<Workout> workouts) {
    _workoutsKeeper.saveWorkouts(workouts);
  }

  void _subscribeToServerChanges() {
    FirebaseDatabase.instance
        .reference()
        .child(_path)
        .onChildAdded
        .listen(_saveWorkoutsAfterSubscriptionDataChanged);
    FirebaseDatabase.instance
        .reference()
        .child(_path)
        .onChildChanged
        .listen(_saveWorkoutsAfterSubscriptionDataChanged);
    FirebaseDatabase.instance
        .reference()
        .child(_path)
        .onChildMoved
        .listen(_saveWorkoutsAfterSubscriptionDataChanged);
    FirebaseDatabase.instance
        .reference()
        .child(_path)
        .onChildRemoved
        .listen(_saveWorkoutsAfterSubscriptionDataChanged);
  }

  List<Workout> _getOldWorkouts(List<Workout> workouts) {
    List<Workout> oldWorkouts = [];
    for (var element in workouts) {
      if (!_compareWorkoutDates(element.date!)) {
        oldWorkouts.add(element);
      }
    }
    return oldWorkouts;
  }

  bool _compareWorkoutDates(String workoutDate) {
    String formattedDate =
        "${workoutDate.substring(4, 8)}-${workoutDate.substring(2, 4)}-${workoutDate.substring(0, 2)}";
    DateTime workoutDateTime = DateTime.parse(formattedDate);
    DateTime now = DateTime.now();
    if (workoutDateTime.isAfter(now)
      ///TODO Заменили тут
      // workoutDateTime.year >= now.year &&
      //   workoutDateTime.day >= now.day &&
      //   workoutDateTime.month >= now.month
        ) {
      return true;
    } else {
      return false;
    }
  }

  List<Workout> _sortWorkouts(List<Workout> workouts) {
    List<Workout> result = [];
    if (workouts.length > 1) {
      workouts.sort((first, second) {
        String formattedDateFirst =
            "${first.date!.substring(4, 8)}-${first.date!.substring(2, 4)}-${first.date!.substring(0, 2)}";
        DateTime workoutDateTimeFirst = DateTime.parse(formattedDateFirst);
        String formattedDateSecond =
            "${first.date!.substring(4, 8)}-${first.date!.substring(2, 4)}-${first.date!.substring(0, 2)}";
        DateTime workoutDateTimeSecond = DateTime.parse(formattedDateSecond);
        return workoutDateTimeFirst.millisecondsSinceEpoch -
            workoutDateTimeSecond.millisecondsSinceEpoch;
      });
      List<Workout> temp = [];
      String currentWorkoutsDate = workouts[0].date!;
      for (var i = 0; i < workouts.length; ++i) {
        if (currentWorkoutsDate == workouts[i].date) {
          temp.add(workouts[i]);
          if (i == workouts.length - 1) {
            temp = _sortWorkoutsByTime(temp);
            result.addAll(temp);
          }
        } else {
          if (i == workouts.length - 1) {
            temp = _sortWorkoutsByTime(temp);
            result.addAll(temp);
            result.add(workouts[i]);
          } else {
            temp = _sortWorkoutsByTime(temp);
            result.addAll(temp);
            temp = [];
            currentWorkoutsDate = workouts[i].date!;
            temp.add(workouts[i]);
          }
        }
      }
    } else {
      result = workouts;
    }
    return result;
  }

  List<Workout> _sortWorkoutsByTime(List<Workout> list) {
    TimesController timesController = TimesController();
    if (list.isNotEmpty) {
      list.sort((first, second) {
        return timesController.times[first.from] -
            timesController.times[second.from];
      });
    }
    return list;
  }

  void _deleteOldWorkoutsFromFirebase(List<Workout> workouts) {
    for (var element in workouts) {
      FirebaseDatabase.instance
          .reference()
          .child(_path + '/' + element.id!)
          .remove();
    }
  }
}
