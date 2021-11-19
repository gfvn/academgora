import 'dart:async';

import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/screens/profile/instructor_profile/set_workout_time_screen/data/instructor_data_controller.dart';
import 'package:academ_gora_release/screens/profile/instructor_profile/set_workout_time_screen/data/instructor_data_controller_impl.dart';
import 'package:academ_gora_release/screens/profile/instructor_profile/set_workout_time_screen/data/instructor_state_keeper.dart';

import 'instructor_data_view_model.dart';

class InstructorDataViewModelImpl implements InstructorDataViewModel, InstructorDataListener{
  final _controller = StreamController<Instructor>.broadcast();

  @override
  void getInstructorData(String? phone) {
    InstructorDataController instructorDataController = InstructorDataControllerImpl(phone);
   instructorDataController.getInstructorData(this);
  }

  @override
  Stream<Instructor> get instructorData => _controller.stream;

  @override
  void updateListener(Instructor instructor) {
      _controller.sink.add(instructor);
  }

  void dispose(){
    _controller.close();
  }

}