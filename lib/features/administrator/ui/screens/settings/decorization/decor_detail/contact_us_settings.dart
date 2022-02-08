import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/components/inputs/main_input.dart';
import 'package:academ_gora_release/main.dart';

import 'package:flutter/material.dart';

class ContactUsSettings extends StatefulWidget {
  const ContactUsSettings({Key? key}) : super(key: key);

  @override
  _ContactUsSettingsState createState() => _ContactUsSettingsState();
}

class _ContactUsSettingsState extends State<ContactUsSettings> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Настройка контакты",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildColumWidget(),
              ],
            ),
            Positioned(
              bottom: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AcademButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      tittle: "Сохранить",
                      width: screenWidth * 0.8,
                      fontSize: 14)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextInput(
      {required TextEditingController controller,
      required TextInputType inputType}) {
    return MainTextField(
      height: 40,
      width: screenWidth * 0.7,
      textInputType: inputType,
      controller: controller,
    );
  }

  Widget buildRoleText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildTextInputs(
      {required TextEditingController controller,
      required String tittle,
      required TextInputType inputType}) {
    return Column(
      children: [
        buildRoleText(tittle),
        buildTextInput(controller: controller, inputType: inputType),
      ],
    );
  }

  Widget buildColumWidget() {
    return Column(
      children: [
        buildTextInputs(
            tittle: "Номер телефона",
            controller: phoneController,
            inputType: TextInputType.phone),
        buildTextInputs(
            tittle: "Номер телефона WhatsApp",
            controller: whatsappController,
            inputType: TextInputType.phone),
        buildTextInputs(
            tittle: "Почта",
            controller: emailController,
            inputType: TextInputType.emailAddress),
      ],
    );
  }
}
