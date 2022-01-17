import 'package:academ_gora_release/common/times_controller.dart';
import 'package:academ_gora_release/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:academ_gora_release/screens/auth/auth_screen.dart';
import 'package:academ_gora_release/screens/profile/user_profile/presentation/workouts_view_model.dart';
import 'package:academ_gora_release/screens/profile/user_profile/presentation/workouts_view_model_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import '../../../../main.dart';
import '../../../extension.dart';
import '../../../main_screen.dart';
import '../../helpers_widgets/workout_widget/workout_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({Key? key}) : super(key: key);

  @override
  _UserAccountScreenState createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  final WorkoutsViewModel _workoutsViewModel = WorkoutsViewModelImpl();
  final TimesController _timesController = TimesController();

  @override
  void initState() {
    super.initState();
    _workoutsViewModel.getWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: screenDecoration("assets/profile/0_bg.png"),
      child: Column(
        children: [
          _topAccountInfo(),
          _workoutsTitle(),
          _workoutsList(),
          _backToMainScreenButton()
        ],
      ),
    ));
  }

  Widget _topAccountInfo() {
    return Container(
        margin: EdgeInsets.only(top: screenHeight * 0.07, right: 10),
        child: Column(
          children: [_accountTextWidget(), _phoneTextWidget(), _logoutButton()],
        ));
  }

  Widget _accountTextWidget() {
    return Container(
      alignment: Alignment.topRight,
      child: const Text(
        "Личный кабинет",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _phoneTextWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      alignment: Alignment.topRight,
      child: Text(
        FirebaseAuth.instance.currentUser!.phoneNumber!,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _logoutButton() {
    return GestureDetector(
      onTap: () {
        showLogoutDialog(context, _logout);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              "ВЫЙТИ",
              style: TextStyle(color: Colors.white),
            ),
            Container(
                margin: const EdgeInsets.only(left: 5),
                height: 20,
                width: 20,
                child: Image.asset("assets/profile/e1.png"))
          ],
        ),
      ),
    );
  }

  Widget _backToMainScreenButton() {
    return GestureDetector(
      onTap: _openMainScreen,
      child: Container(
        alignment: Alignment.center,
        width: screenWidth * 0.5,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(top: screenHeight * 0.01),
        decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(26))),
        child: Text(
          "НА ГЛАВНУЮ",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _logout() async {
    FirebaseAuth.instance.currentUser!.delete;
    FlutterAuthUi.signOut();
    var pref = await SharedPreferences.getInstance();
    pref.remove("userRole");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const AuthScreen()),
        (route) => false);
  }

  void _openMainScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const MainScreen()),
        (route) => false);
  }

  Widget _workoutsTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, bottom: 10),
      alignment: Alignment.centerLeft,
      child: const Text(
        "мои занятия",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _workoutsList() {
    return SizedBox(
      height: screenHeight * 0.6,
      child: StreamBuilder(
        stream: _workoutsViewModel.workoutsList,
        builder: (context, snap) {
          return snap.hasData
              ? ListView.builder(
                  itemCount: (snap.data as List<Workout>).length,
                  itemBuilder: (context, index) {
                    List<Workout> workouts = snap.data as List<Workout>;

                    ///TODO change here
                    //     _sortWorkoutsByDateAndTime(snap.data as List<Workout>);
                    return Column(
                      children: [
                        WorkoutWidget(
                          workout: workouts[index],
                        ),
                        index != workouts.length - 1
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                              )
                            : Container()
                      ],
                    );
                  },
                )
              : const Text(
                  'nooo',
                );
        },
      ),
    );
  }

  List<Workout> _sortWorkoutsByTime(List<Workout> list) {
    if (list.isNotEmpty) {
      list.sort((first, second) {
        return _timesController.times[first.from] -
            _timesController.times[second.from];
      });
    }
    return list;
  }

  List<Workout> _sortWorkoutsByDate(List<Workout> list) {
    if (list.isNotEmpty) {
      list.sort((first, second) {
        String firstDate =
            "${first.date!.substring(4, 8)}-${second.date!.substring(2, 4)}-${second.date!.substring(0, 2)}";
        DateTime dateTimeFirst = DateTime.parse(firstDate);
        String secondDate =
            "${first.date!.substring(4, 8)}-${second.date!.substring(2, 4)}-${second.date!.substring(0, 2)}";
        DateTime dateTimeSecond = DateTime.parse(secondDate);
        if (dateTimeFirst.isAfterDate(dateTimeSecond)) {
          return 1;
        } else if (dateTimeFirst.isBeforeDate(dateTimeSecond)) {
          return -1;
        } else {
          return 0;
        }
      });
    }
    return list;
  }

  List<Workout> _sortWorkoutsByDateAndTime(List<Workout> list) {
    List<Workout> sorted = [];
    List<Workout> workoutsPerDate = [];
    if (list.isNotEmpty) {
      String currentWorkoutDate = list[0].date!;
      workoutsPerDate.add(list[0]);
      List<Workout> sortedByDate = _sortWorkoutsByDate(list);
      for (Workout workout in sortedByDate) {
        if (workout.date == currentWorkoutDate &&
            !workoutsPerDate.contains(workout)) {
          workoutsPerDate.add(workout);
        } else if (!workoutsPerDate.contains(workout)) {
          sorted.addAll(_sortWorkoutsByTime(workoutsPerDate));
          workoutsPerDate = [];
          workoutsPerDate.add(workout);
          currentWorkoutDate = workout.date!;
          if (sortedByDate.last == workout) {
            sorted.add(workout);
          }
        }
      }
    }
    return sorted;
  }

  @override
  void dispose() {
    super.dispose();
    InstructorsKeeper().removeListener(this);
  }
}
