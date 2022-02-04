import 'package:academ_gora_release/core/common/times_controller.dart';
import 'package:academ_gora_release/core/components/dialogs/dialogs.dart';
import 'package:academ_gora_release/core/components/dialogs/message_dialog.dart';
import 'package:academ_gora_release/core/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';
import 'package:academ_gora_release/features/main_screen/domain/enteties/workout.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

import '../../../../main.dart';
import '../../registration_parameters_screen.dart';

class SelectDurationWidget extends StatefulWidget {
  final int? selectedDuration;
  final RegistrationParametersScreenState registrationParametersScreenState;

  const SelectDurationWidget(
      this.selectedDuration, this.registrationParametersScreenState,
      {Key? key})
      : super(key: key);

  @override
  _SelectDurationWidgetState createState() =>
      // ignore: no_logic_in_create_state
      _SelectDurationWidgetState(selectedDuration);
}

class _SelectDurationWidgetState extends State<SelectDurationWidget> {
  int? _selectedDuration;

  final WorkoutDataKeeper _workoutSingleton = WorkoutDataKeeper();
  final TimesController _timesController = TimesController();
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();

  _SelectDurationWidgetState(this._selectedDuration);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _workoutDurationTitle(),
        _countButtons(),
      ],
    );
  }

  Widget _workoutDurationTitle() {
    return Container(
        margin: EdgeInsets.only(left: screenWidth * 0.03),
        child: const Text(
          "Длительность\nзанятия",
          style: TextStyle(fontSize: 12, color: kMainColor),
        ));
  }

  Widget _countButtons() {
    return Container(
        margin: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _countButton(0),
            _countButton(1, leftMargin: 10),
          ],
        ));
  }

  Widget _countButton(int which, {double leftMargin = 0}) {
    return Container(
      margin: EdgeInsets.only(left: leftMargin),
      child: GestureDetector(
        onTap: () => _checkSelectionPossibility(which),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(
                image: AssetImage(_createBackgroundOfCountButton(which)),
                fit: BoxFit.fill),
          ),
          height: screenHeight * 0.045,
          width: screenWidth * 0.29,
          padding: const EdgeInsets.only(right: 12),
          alignment: Alignment.centerRight,
          child: Text(
            which == 0 ? "1 час" : "2 часа",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                    which == _selectedDuration ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  void _checkSelectionPossibility(int which) {
    int duration = which == 0 ? 1 : 2;
    if (duration == 2) {
      bool possibility;
      Instructor? instructor = _instructorsKeeper.findInstructorByPhoneNumber(
          _workoutSingleton.instructorPhoneNumber!);
      possibility = _timesController.checkTimesStatusForTwoHours(
          instructor!.schedule![_workoutSingleton.date],
          _workoutSingleton.from!,
          "открыто");
      if (possibility) {
        _updateStateAfterSelection(which);
      } else {
    Dialogs.showUnmodal(
        context,
        const MessageDialog(
          title: "Не доступно",
          text: "На выбранное время запись возможна только на 1 час",
        ),
      );      }
    } else {
      _updateStateAfterSelection(which);
    }
  }

  void _updateStateAfterSelection(int which) {
    _selectedDuration = which;
    _workoutSingleton.workoutDuration = _selectedDuration == 0 ? 1 : 2;
    widget.registrationParametersScreenState.setState(() {
      widget.registrationParametersScreenState.duration =
          _selectedDuration == 0 ? 1 : 2;
    });
    setState(() {});
  }

  void _showWarningxsxDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            "На выбранное время запись возможна только на 1 час",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text(
                'ОК',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _createBackgroundOfCountButton(int which) {
    return which == _selectedDuration
        ? "assets/registration_to_instructor/3_e2.png"
        : "assets/registration_to_instructor/3_e1.png";
  }
}
