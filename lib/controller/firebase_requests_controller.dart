import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../main.dart';

class FirebaseRequestsController {
  static final FirebaseRequestsController _firebaseRequestsController =
      FirebaseRequestsController._internal();
  late MyAppState? myAppState;

  FirebaseRequestsController._internal();

  factory FirebaseRequestsController() {
    return _firebaseRequestsController;
  }

  void addListener(String path, Function(Event?) function) {
    FirebaseDatabase.instance
        .reference()
        .child(path)
        .onChildAdded
        .listen(function);
    FirebaseDatabase.instance
        .reference()
        .child(path)
        .onChildChanged
        .listen(function);
    FirebaseDatabase.instance
        .reference()
        .child(path)
        .onChildMoved
        .listen(function);
    FirebaseDatabase.instance
        .reference()
        .child(path)
        .onChildRemoved
        .listen(function);
  }

  void send(String path, var map) {
    FirebaseDatabase.instance.reference().child(path).set(map);
  }

  Future<void> update(String path, var map) async {
    FirebaseDatabase.instance.reference().child(path).update(map);
  }

  Future<Map> get(String path) async {
    DataSnapshot dataSnapshot =
        await FirebaseDatabase.instance.reference().child(path).once();
    return dataSnapshot.value as Map<dynamic, dynamic>;
  }

  Future<String> getDownloadUrlFromFirebaseStorage(String path) async {
    String url =
        await FirebaseStorage.instance.ref().child(path).getDownloadURL();
    return url;
  }

  Future<void> uploadFileToFirebaseStorage(String path, File file)async{
    await FirebaseStorage.instance.ref().child(path).putFile(file);
  }

  Future<void> delete(String path) async {
    return FirebaseDatabase.instance.reference().child(path).remove();
  }
}
