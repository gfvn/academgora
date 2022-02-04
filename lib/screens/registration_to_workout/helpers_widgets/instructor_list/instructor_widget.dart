import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';
import 'package:academ_gora_release/features/main_screen/domain/enteties/reg_to_instructor_data.dart';
import 'package:academ_gora_release/screens/instructor_profile/instructor_profile_screen.dart';
import 'package:academ_gora_release/screens/profile/instructor_profile/instructor_photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../main.dart';
import '../../instructors_list_screen.dart';
import 'datetime_picker_widget.dart';

class InstructorWidget extends StatefulWidget {
  final Instructor instructor;
  final InstructorsListScreenState instructorsListScreenState;

  const InstructorWidget(this.instructor, this.instructorsListScreenState,
      {Key? key})
      : super(key: key);

  @override
  InstructorWidgetState createState() => InstructorWidgetState();
}

class InstructorWidgetState extends State<InstructorWidget> {
  RegToInstructorData? regToInstructorData;
  Instructor? instructor;

  @override
  Widget build(BuildContext context) {
    regToInstructorData = widget.instructorsListScreenState.regToInstructorData;
    instructor = widget.instructor;
    return ExpandablePanel(
      header: _header(),
      expanded: _body(),
      collapsed: _body(),
    );
  }

  Widget _header() {
    return SizedBox(
      height: 65,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (c) => InstructorProfileScreen(instructor!)));
            },
            child: InstructorPhotoWidget(
              instructor!,
              width: screenHeight * 0.1,
              height: screenHeight * 0.1,
            ),
          ),
          Container(
              width: screenWidth * 0.5,
              margin: const EdgeInsets.only(left: 12),
              child: Text(
                instructor!.name ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget _body() {
    return Row(
      children: [
        _openProfileButton(),
        DateTimePickerWidget(
          this,
          instructor: instructor!,
        )
      ],
    );
  }

  Widget _openProfileButton() {
    return GestureDetector(
      onTap: _openProfile,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          image: DecorationImage(
            image: AssetImage("assets/instructors_list/e_9.png"),
            fit: BoxFit.cover,
          ),
        ),
        height: 43,
        width: 67,
        padding: const EdgeInsets.all(1),
        child: const Text(
          "открыть\nпрофиль",
          style: TextStyle(color: Color(0xff007CC0), fontSize: 14),
        ),
      ),
    );
  }

  void _openProfile() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (c) => InstructorProfileScreen(instructor!)));
  }

  @override
  void setState(fn) {
    super.setState(fn);
    widget.instructorsListScreenState.setState(() {
      widget.instructorsListScreenState.regToInstructorData =
          regToInstructorData;
    });
  }
}
