class Contact{
  String? phone;
  String? whats;
  String? email;

  Contact({this.email,this.phone,this.whats});

  Contact.fromJson(Map<dynamic,dynamic> json){
    phone = json['Телефон'];
    whats = json['WhatsApp'];
    email = json['Почта'];
  }

  Map<String,dynamic> toJson(){
    return {
      'Телефон':phone,
      'WhatsApp':whats,
      'Почта':email,
    };
  }

}


// static Contact fromJson(String id, contactModelApi) {
// Contact contactModel = Contact();
// contactModel.phone = contactModelApi['Телефон'];
// contactModel.whats = contactModelApi['WhatsApp'];
// contactModel.phone = contactModelApi['Почта'];
// return contactModel;
// }