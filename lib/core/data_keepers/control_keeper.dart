import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/contact.dart';

class ContactKeeper{

  static final ContactKeeper _contactKeeper = ContactKeeper._();

  ContactKeeper._();

  factory ContactKeeper() {
    return _contactKeeper;
  }

  Contact contact = Contact();

  void getInfo(Map value) {
    contact = Contact.fromJson(value);
  }
}