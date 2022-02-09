
import 'package:academ_gora_release/features/administrator/ui/screens/help_screens/filter_screens.dart';
import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';

class FilterKeeper {
  // ignore: non_constant_identifier_names
  static final FilterKeeper _FilterKeeper = FilterKeeper._internal();
  FilterKeeper._internal();

  List<Instructor> filteredInstructorList = [];
  List<Instructor> instuctorList = [];
  List<CheckBoxState> instructorCheckBoxList = [];
  bool isSkiesSelected = true;
  bool isSnowBoardSelected = true;
  bool isCompleteSelected = true;
  bool isCanceledSelected = true;
  DateTime firstDate = DateTime.now();
  DateTime secondDate = DateTime.now();
  CheckBoxStateAll allInstructorChecBoxState = CheckBoxStateAll(tittle: "Все");

  factory FilterKeeper() {
    return _FilterKeeper;
  }
  void createChecBoxList() {
    instructorCheckBoxList = List.generate(
      instuctorList.length,
      (index) {
        return CheckBoxState(instructor: instuctorList[index]);
      },
    );
  }

  void saveInstructorList(List<Instructor> list) {
    filteredInstructorList = List.from(list);
    instuctorList = List.from(list);
    createChecBoxList();
  }

  void updateFilterL({
    required bool fisSkiesSelected,
    required bool fisSnowBoardSelected,
    required bool fisCompleteSelected,
    required bool fisCanceledSelected,
    required List<Instructor> ffilterList,
    required DateTime ffirstTime,
    required DateTime fsecondTime,
    required CheckBoxStateAll fallInctructorCheck,
    required List<CheckBoxState> finstructorCheckBoxList,
  }) {
    isSkiesSelected = fisSkiesSelected;
    isSnowBoardSelected = fisSnowBoardSelected;
    isCompleteSelected = fisCompleteSelected;
    isCanceledSelected = fisCanceledSelected;
    filteredInstructorList = ffilterList;
    firstDate = ffirstTime;
    secondDate = fsecondTime;
    allInstructorChecBoxState = fallInctructorCheck;
  }



  void clearfilter() {
    isSkiesSelected = true;
    isSnowBoardSelected = true;
    isCompleteSelected = true;
    isCanceledSelected = true;
    filteredInstructorList = List.from(instuctorList);
    firstDate = DateTime.now();
    secondDate = DateTime.now();
    allInstructorChecBoxState = CheckBoxStateAll(tittle: "Все");

    createChecBoxList();
  }
}
