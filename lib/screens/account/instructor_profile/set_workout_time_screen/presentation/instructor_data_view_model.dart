import 'package:academ_gora_release/model/instructor.dart';

abstract class InstructorDataViewModel{
  Stream<Instructor> get instructorData;
  void getInstructorData(String? phone);
}