
import 'package:academ_gora_release/features/user/user_profile/domain/enteties/personal.dart';
import 'package:flutter/material.dart';

class UsersKeeper {
  static final UsersKeeper _instructorsKeeper = UsersKeeper._internal();

  List<User> userList = [];
  List<State> _listeners = [];

  UsersKeeper._internal();

  factory UsersKeeper() {
    return _instructorsKeeper;
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
    userList = [];
    instructors.forEach((key, value) {
      userList.add(User.fromJson(key, value));
    });
    _updateListeners();
  }

  List<User> getAllPersons() {
    return userList;
  }

  User? findInstructorByPhoneNumber(String phoneNumber) {
    User? instructor;
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
