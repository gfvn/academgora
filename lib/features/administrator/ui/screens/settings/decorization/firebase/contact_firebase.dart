import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/contact.dart';

class ContactFirebase {

  static final ContactFirebase _contactFirebase = ContactFirebase._();

  ContactFirebase._();

  factory ContactFirebase() {
    return _contactFirebase;
  }
  Contact contact = Contact();
  final FirebaseRequestsController _firebaseController =
  FirebaseRequestsController();


  void createInstructor(String phone, String phoneWhats, String mail)
  {
    _firebaseController.send(
      "Info/contact",
      {
        "Телефон": phone,
        "WhatsApp": phoneWhats,
        "Почта": mail,
      },
    );
  }

  void getInfo() async {
    await _firebaseController.get('Info/contact').then((value) {
      contact = Contact.fromJson(value);
      print(value);
    });

  }
}