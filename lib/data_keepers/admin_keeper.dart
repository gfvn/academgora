import 'package:academ_gora_release/model/administrator.dart';
import 'package:flutter/material.dart';

class AdminKeeper {
  static final AdminKeeper _instructorsKeeper = AdminKeeper._internal();

  List<Adminstrator> userList = [];
  List<State> _listeners = [];

  AdminKeeper._internal();

  factory AdminKeeper() {
    return _instructorsKeeper;
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
    userList = [];
    instructors.forEach((key, value) {
      userList.add(Adminstrator.fromJson(key, value));
    });
    _updateListeners();
  }

  List<Adminstrator> getAllPersons() {
    return userList;
  }

  Adminstrator? findInstructorByPhoneNumber(String phoneNumber) {
    Adminstrator? instructor;
    for (var element in userList) {
      if (element.phone == phoneNumber) {
        instructor = element;
      }
    }
    return instructor;
  }

  void clear() {
    userList = [];
    _listeners = [];
  }
}
