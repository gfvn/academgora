import 'package:academ_gora_release/model/cancel.dart';
import 'package:flutter/material.dart';

class CancelKeeper {
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
