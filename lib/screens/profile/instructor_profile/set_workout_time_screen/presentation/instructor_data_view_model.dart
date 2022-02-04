import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';

abstract class InstructorDataViewModel{
  Stream<Instructor> get instructorData;
  void getInstructorData(String? phone);
}