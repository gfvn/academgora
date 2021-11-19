import 'package:academ_gora_release/model/instructor.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'instructor_data_controller.dart';
import 'instructor_state_keeper.dart';

class InstructorDataControllerImpl implements InstructorDataController {
  final InstructorStateKeeper _instructorStateKeeper = InstructorStateKeeper();
  final String _path = "Инструкторы";
  final String? _phone;

  InstructorDataControllerImpl(this._phone);

  @override
  void getInstructorData(InstructorDataListener listener) async {
    _instructorStateKeeper.setListener(listener);
    _saveInstructorIntoKeeper();
    _subscribeToServerChanges();
  }

  void _saveInstructorIntoKeeper() async {
    List<Instructor> instructors = _parseFirebaseResponseToInstructorsList(
        await _getInstructorsFromFirebase());
    if (_phone != null && _phone!.isNotEmpty) {
      _instructorStateKeeper.saveInstructorData(
          _findInstructorByPhoneNumber(_phone!, instructors));
    } else {
      _instructorStateKeeper
          .saveInstructorData(_findInstructorByUid(instructors));
    }
  }

  Future<Map> _getInstructorsFromFirebase() async {
    DataSnapshot dataSnapshot =
        await FirebaseDatabase.instance.reference().child(_path).once();
    return dataSnapshot.value == null
        ? {}
        : dataSnapshot.value as Map<dynamic, dynamic>;
  }

  List<Instructor> _parseFirebaseResponseToInstructorsList(Map? instructors) {
    List<Instructor> _instructorsList = [];
    if (instructors != null) {
      instructors.forEach((key, value) {
        _instructorsList.add(Instructor.fromJson(key, value));
      });
    }

    return _instructorsList;
  }

  Instructor _findInstructorByPhoneNumber(
      String phoneNumber, List<Instructor> instructors) {
    Instructor? instructor;
    for (var element in instructors) {
      if (element.phone == phoneNumber) {
        instructor = element;
      }
    }
    return instructor!;
  }

  Instructor _findInstructorByUid(List<Instructor> instructors) {
    Instructor? instructor;
    for (var element in instructors) {
      if (element.id == FirebaseAuth.instance.currentUser!.uid) {
        instructor = element;
      }
    }
    return instructor!;
  }

  void _subscribeToServerChanges() {
    FirebaseDatabase.instance
        .reference()
        .child(_path)
        .onChildAdded
        .listen(_saveInstructorAfterSubscriptionDataChanged);
    FirebaseDatabase.instance
        .reference()
        .child(_path)
        .onChildChanged
        .listen(_saveInstructorAfterSubscriptionDataChanged);
    FirebaseDatabase.instance
        .reference()
        .child(_path)
        .onChildMoved
        .listen(_saveInstructorAfterSubscriptionDataChanged);
    FirebaseDatabase.instance
        .reference()
        .child(_path)
        .onChildRemoved
        .listen(_saveInstructorAfterSubscriptionDataChanged);
  }

  void _saveInstructorAfterSubscriptionDataChanged(Event event) async {
    _saveInstructorIntoKeeper();
  }
}
