import 'package:academ_gora_release/model/instructor.dart';
import 'package:flutter/material.dart';

class InstructorsKeeper {
  static final InstructorsKeeper _instructorsKeeper =
      InstructorsKeeper._internal();

  List<Instructor> instructorsList = [];
  List<State> _listeners = [];

  InstructorsKeeper._internal();

  factory InstructorsKeeper() {
    return _instructorsKeeper;
  }

  void _updateListeners() {
    _listeners.forEach((element) {
      element.setState(() {});
    });
  }

  void addListener(State listener) {
    bool contains = false;
    _listeners.forEach((element) {
      if (element.runtimeType == listener.runtimeType) contains = true;
    });
    if (!contains) _listeners.add(listener);
  }

  void removeListener(State listener) {
    bool contains = false;
    _listeners.forEach((element) {
      if (element.runtimeType == listener.runtimeType) contains = true;
    });
    if (contains) _listeners.remove(listener);
  }

  void updateInstructors(Map instructors) {
    instructorsList = [];
    instructors.forEach((key, value) {
      instructorsList.add(Instructor.fromJson(key, value));
    });
    _updateListeners();
  }

  List<Instructor> findInstructorsByKindOfSport(String kindOfSport) {
    List<Instructor> filtered = [];
    instructorsList.forEach((element) {
      if (element.kindOfSport == kindOfSport) filtered.add(element);
    });
    return filtered;
  }

  Instructor? findInstructorByPhoneNumber(String phoneNumber) {
    Instructor? instructor;
    instructorsList.forEach((element) {
      if (element.phone == phoneNumber) {
        instructor = element;
      }
    });
    return instructor;
  }

  void clear() {
    instructorsList = [];
    _listeners = [];
  }
}
