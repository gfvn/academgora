import 'dart:developer';

import 'package:academ_gora_release/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/model/news.dart';
import 'package:flutter/material.dart';

class NewsKeeper {
  static final NewsKeeper _instructorsKeeper = NewsKeeper._internal();

  List<News> newsList = [];
  List<String> newsUrl = [];
  List<State> _listeners = [];
  final FirebaseRequestsController _firebaseRequestsController =
      FirebaseRequestsController();

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
    updateNewsUrls();
    _updateListeners();
  }

  void updateNewsUrls() async {
    newsUrl = [];
    log('urrrlUpdate');
    for (News news in newsList) {
      final String url = await saveImageUrl(imageName: news.photo.toString());
      newsUrl.add(url);
    }
  }

  Future<String> saveImageUrl({required String imageName}) async {
    String url = "";
    if (imageName == "") {
      return url;
    }
    await _firebaseRequestsController
        .getDownloadUrlFromFirebaseStorage("news_photos/$imageName")
        .then(
      (downloadUrl) {
        url = downloadUrl.toString();
      },
    );
    return url;
  }

  List<News> getAllPersons() {
    return newsList;
  }

  List<String> getNewsUrls() {
    return newsUrl;
  }

  void setUrlToList(String url) {
    newsUrl.add(url);
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
