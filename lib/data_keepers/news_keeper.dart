import 'dart:developer';

import 'package:academ_gora_release/model/news.dart';
import 'package:flutter/material.dart';

class NewsKeeper {
  static final NewsKeeper _instructorsKeeper = NewsKeeper._internal();

  List<News> newsList = [];
  List<State> _listeners = [];

  NewsKeeper._internal();
  factory NewsKeeper() {
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

  void updateInstructors(List news) {
    newsList = [];
    news.map((e) {
      newsList.add(News.fromJson(e));
    }).toList();
    _updateListeners();
  }

  List<News> getAllPersons() {
    return newsList;
  }

  // NewsKeeper? findInstructorByPhoneNumber(String phoneNumber) {
  //   NewsKeeper? instructor;
  //   for (var element in newsList) {
  //     if (element.phone == phoneNumber) {
  //       instructor = element;
  //     }
  //   }
  //   return instructor;
  // }

  void clear() {
    newsList = [];
    _listeners = [];
  }
}
