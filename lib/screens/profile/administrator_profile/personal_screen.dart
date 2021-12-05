import 'dart:async';
import 'dart:developer';

import 'package:academ_gora_release/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/components/search_widget.dart';
import 'package:academ_gora_release/data_keepers/admin_keeper.dart';
import 'package:academ_gora_release/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/data_keepers/user_keepaers.dart';
import 'package:academ_gora_release/main.dart';
import 'package:academ_gora_release/model/administrator.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/model/personal.dart';
import 'package:academ_gora_release/model/user_role.dart';
import 'package:academ_gora_release/screens/extension.dart';
import 'package:flutter/material.dart';

class PersonalScreeen extends StatefulWidget {
  const PersonalScreeen({Key? key}) : super(key: key);

  @override
  _PersonalScreeenState createState() => _PersonalScreeenState();
}

final UsersKeeper _userKeeper = UsersKeeper();
final InstructorsKeeper _instructorKeeper = InstructorsKeeper();
final AdminKeeper _adminKeeper = AdminKeeper();

class _PersonalScreeenState extends State<PersonalScreeen> {
  String query = '';
  Timer? debouncer;
  bool isLoading = false;
  List<User> personalList = [];
  List<User> filteredPersonList = [];
  List<Instructor> instructorlist = [];
  List<Instructor> filteredInstructorList = [];
  List<Adminstrator> adminlist = [];
  List<Adminstrator> filteredAdminList = [];
  final FirebaseRequestsController _firebaseController =
      FirebaseRequestsController();
  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _getUsers();
    filteredPersonList = personalList;

    _getAdmins();
    filteredAdminList = adminlist;

    _getInstructors();
    filteredInstructorList = instructorlist;

    super.initState();
  }

  void _getUsers() {
    personalList = _userKeeper.getAllPersons();
    log('userrrrrr $personalList');
  }

  void _getAdmins() {
    adminlist = _adminKeeper.getAllPersons();
  }

  void _getInstructors() {
    instructorlist = _instructorKeeper.instructorsList;
  }

  void search(String query) {
    filteredPersonList = [];
    filteredInstructorList = [];
    filteredAdminList = [];

    final person = personalList.where((user) {
      final titleLower = user.phone ?? user.phone!.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    final instructor = instructorlist.where((user) {
      final titleLower = user.phone ?? user.phone!.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    final admin = adminlist.where((user) {
      final titleLower = user.phone ?? user.phone!.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      query = query;
      filteredPersonList = person;
      filteredInstructorList = instructor;
      filteredAdminList = admin;
    });
  }

  void searchInAdmins() {
    filteredAdminList = [];
    final user = adminlist.where((user) {
      final titleLower = user.phone ?? user.phone!.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      query = query;
      filteredAdminList = user;
    });
  }

  void makeInstructorToAdmin(Instructor instructor) {
    filteredInstructorList.remove(instructor);
    deleteInstructor(instructor.id.toString());
    createAdmin(instructor.id.toString(), instructor.phone.toString());
  }

  void makeInstructorToUser(Instructor instructor) {
    filteredInstructorList.remove(instructor);
    deleteInstructor(instructor.id.toString());
    createUser(instructor.id.toString(), instructor.phone.toString());
  }

  void deleteInstructor(String urlId) {
    _firebaseController.delete("${UserRole.instructor}/$urlId");
  }

  void createInstructor(String phone, String uuid, String kindOfSport) {
    _firebaseController.send("${UserRole.instructor}/$uuid", {
      "Телефон": phone,
      "Вид спорта": kindOfSport,
    });
  }

  void makeAdminToUser(Adminstrator administrator) {
    filteredAdminList.remove(administrator);
    deleteAdmin(administrator.id.toString());
    createUser(administrator.id.toString(), administrator.phone.toString());
  }

  void makeAdminToInstructor(Adminstrator administrator, String kindOfSport) {
    filteredAdminList.remove(administrator);
    deleteAdmin(administrator.id.toString());
    createInstructor(administrator.phone.toString(),
        administrator.id.toString(), kindOfSport);
  }

  void deleteAdmin(String urlId) {
    _firebaseController.delete("${UserRole.administrator}/$urlId");
  }

  void createAdmin(String uuid, String phone) {
    _firebaseController
        .send("${UserRole.administrator}/$uuid", {"Телефон": phone});
  }

  void makeUserToInstructor(User user, String kindofSport) {
    filteredPersonList.remove(user);
    deleteUser(user.id.toString());
    createInstructor(user.phone.toString(), user.id.toString(), kindofSport);
  }

  void makeUserToAdmin(User user) {
    filteredPersonList.remove(user);
    deleteUser(user.id.toString());
    createAdmin(user.id.toString(), user.phone.toString());
  }

  void deleteUser(String urlId) {
    _firebaseController.delete("${UserRole.user}/$urlId");
  }

  void createUser(String uid, String phone) {
    _firebaseController.send("${UserRole.user}/$uid", {"Телефон": phone});
  }

  Future<void> onRefresh() async {
    _getUsers();
    _getAdmins();
    _getInstructors();
    setState(() {
      filteredPersonList = personalList;
      filteredAdminList = adminlist;
      filteredInstructorList = instructorlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Container(
            decoration: screenDecoration("assets/all_instructors/bg.png"),
            child: !isLoading
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 32, bottom: 20, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSearch(),
                        const SizedBox(
                          height: 8,
                        ),
                        buildInstructionText(),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildRoleText("Инструкторы:"),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        buildInstructorListView(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildRoleText("Администраторы:"),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        buildAdminListView(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildRoleText("Персонали:"),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        buildPersonalView()
                      ],
                    ),
                  )
                : Container(
                    height: screenHeight,
                    width: screenWidth,
                    // ignore: prefer_const_constructors
                    child: Center(
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildInstructorListView() {
    return Column(
      children: List.generate(
        filteredInstructorList.length,
        (int index) {
          return Dismissible(
              background: Container(
                color: Colors.blue,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Сделать \nадмин',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              secondaryBackground: Container(
                color: Colors.green,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Сделать \n юзер',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              key:
                  ValueKey<String>(filteredInstructorList[index].id.toString()),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.startToEnd) {
                  showRoleChangeDialog(
                      context: context,
                      function: () {
                        makeInstructorToAdmin(filteredInstructorList[index]);
                      },
                      role: "Администратор");
                } else {
                  showRoleChangeDialog(
                    context: context,
                    function: () {
                      makeInstructorToUser(filteredInstructorList[index]);
                    },
                    role: "Юзер",
                  );
                }
              },
              child: buildInstructor(filteredInstructorList[index]));
        },
      ),
    );
  }

  Widget buildAdminListView() {
    return Column(
      children: List.generate(
        filteredAdminList.length,
        (int index) {
          return Dismissible(
            background: Container(
              color: Colors.blue,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Сделать \nинструктор',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            secondaryBackground: Container(
              color: Colors.green,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Сделать \n юзер',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            key: ValueKey<String>(filteredAdminList[index].id.toString()),
            onDismissed: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                await showInstructorKindOfSportDialog(
                  context: context,
                  role: "Инструктор",
                ).then(
                  (value) {
                    makeAdminToInstructor(
                      filteredAdminList[index],
                      value.toString(),
                    );
                  },
                );
              } else {
                showRoleChangeDialog(
                  context: context,
                  function: () {
                    makeAdminToUser(filteredAdminList[index]);
                  },
                  role: "Юзер",
                );
              }
            },
            child: buildAdministrator(
              filteredAdminList[index],
            ),
          );
        },
      ),
    );
  }

  Widget buildPersonalView() {
    return Column(
      children: List.generate(
        filteredPersonList.length,
        (int index) {
          return Dismissible(
            background: Container(
              color: Colors.blue,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Седелать \nинструктор',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            secondaryBackground: Container(
              color: Colors.green,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Сделать \nадминистратор',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            key: ValueKey<String>(filteredPersonList[index].id.toString()),
            onDismissed: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                await showInstructorKindOfSportDialog(
                  context: context,
                  role: "Инструктор",
                ).then((value) {
                  makeUserToInstructor(
                    filteredPersonList[index],
                    value.toString(),
                  );
                });
              } else {
                showRoleChangeDialog(
                  context: context,
                  function: () {
                    makeUserToAdmin(filteredPersonList[index]);
                  },
                  role: "Администратор",
                );
              }
            },
            child: buildUser(
              filteredPersonList[index],
            ),
          );
        },
      ),
    );
  }

  Widget buildRoleText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget buildInstructionText() {
    return const Text(
      "Для изменения роли пользователя, проведите по экрану влево или вправо",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget buildUser(User user) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.phone.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          buildLine()
        ],
      ),
    );
  }

  Widget buildInstructor(Instructor user) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user.phone.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                user.name.toString() != null ? user.name.toString() : '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            user.kindOfSport.toString(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
          ),
          buildLine()
        ],
      ),
    );
  }

  Widget buildAdministrator(Adminstrator user) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 8,
        left: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.phone.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          buildLine()
        ],
      ),
    );
  }

  Widget buildLine() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
          height: 1,
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5))),
    );
  }

  Widget buildSearch() => SearchWidget(
      text: query,
      hintText: 'Введите номер телефона пользователя',
      onChanged: search);
}
