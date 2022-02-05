import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/cancel.dart';
import 'package:flutter/material.dart';

class CancelKeeper {
  // ignore: non_constant_identifier_names
  static final CancelKeeper _CancelKeeper =
      CancelKeeper._internal();

  List<CancelModel> cancelModels = [];
  List<State> _listeners = [];

  CancelKeeper._internal();

  factory CancelKeeper() {
    return _CancelKeeper;
  }

  void _updateListeners() {
    for (var element in _listeners) {
      // ignore: invalid_use_of_protected_member
      element.setState(() {});
    }
  }

  void addListener(State listener) {
    bool contains = false;
    for (var element in _listeners) {
      if (element.runtimeType == listener.runtimeType) contains = true;
    }
    if (!contains) _listeners.add(listener);
  }

  void removeListener(State listener) {
    bool contains = false;
    for (var element in _listeners) {
      if (element.runtimeType == listener.runtimeType) contains = true;
    }
    if (contains) _listeners.remove(listener);
  }

  void updateInstructors(Map instructors) {
    cancelModels = [];
    instructors.forEach((key, value) {
      cancelModels.add(CancelModel.fromJson(key, value));
    });
    _updateListeners();
  }

  // List<Instructor> findInstructorsByKindOfSport(String kindOfSport) {
  //   List<Instructor> filtered = [];
  //   for (var element in cancelModels) {
  //     if (element.kindOfSport == kindOfSport) filtered.add(element);
  //   }
  //   return filtered;
  // }

  // Instructor? findInstructorByPhoneNumber(String phoneNumber) {
  //   Instructor? instructor;
  //   for (var element in cancelModels) {
  //     if (element.phone == phoneNumber) {
  //       instructor = element;
  //     }
  //   }
  //   return instructor;
  // }

  void clear() {
    cancelModels = [];
    _listeners = [];
  }
}
