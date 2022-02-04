import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';

class InstructorStateKeeper{
  static final InstructorStateKeeper _instructorStateKeeper = InstructorStateKeeper._internal();
  late InstructorDataListener _listener;

  InstructorStateKeeper._internal();

  factory InstructorStateKeeper() {
    return _instructorStateKeeper;
  }

  void saveInstructorData(Instructor instructor) {
    _listener.updateListener(instructor);
  }

  void setListener(InstructorDataListener listener){
    _listener = listener;
  }
}

abstract class InstructorDataListener{
  void updateListener(Instructor instructor);
}