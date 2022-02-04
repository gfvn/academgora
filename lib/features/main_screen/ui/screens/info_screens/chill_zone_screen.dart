import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:academ_gora_release/features/main_screen/ui/screens/main_screen/main_screen.dart';
import 'package:academ_gora_release/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = [
  "assets/info_screens/chill_zone/chill_zone.jpg",
];

class ChillZoneScreen extends StatefulWidget {
  const ChillZoneScreen({Key? key}) : super(key: key);

  @override
  _ChillZoneScreenState createState() => _ChillZoneScreenState();
}

class _ChillZoneScreenState extends State<ChillZoneScreen> {
  int _current = 0;

  final String _phoneNumber = "89646546227";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ЗОНА ОТДЫХА И ДЕТСКОГО ДОСУГА",
          style: TextStyle(fontSize: 14),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: screenDecoration("assets/info_screens/chill_zone/bg.png"),
        child: Column(
          children: [
            _slider(),
            _description(),
            AcademButton(
              tittle: 'НА ГЛАВНУЮ',
              onTap: _openMainScreen,
              width: screenWidth * 0.9,
              fontSize: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          CarouselSlider(
            items: _getImagesForSlider(),
            options: CarouselOptions(
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(
                  () {
                    _current = index;
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map(
              (url) {
                int index = imgList.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? const Color.fromRGBO(0, 0, 0, 0.9)
                        : const Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> _getImagesForSlider() {
    return imgList
        .map(
          (item) => Container(
            margin: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Image.asset(item),
          ),
        )
        .toList();
  }

  Widget _description() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
      height: screenHeight * 0.5,
      child: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Дорогие гости!\n\n"
              "Приглашаем Вас отдохнуть на Второй этаж. Вас ждет приятная атмосфера для отдыха и ожидания.\n\n"
              "Для Вас услуги буфета и платной комфортабельной зоны отдыха для взрослых и детей: wi-fi, зона детского досуга, настольные игры для детей и взрослых, теплый туалет, массажер для ног, горячий шашлык и вкусные домашние колбаски от Коляна. Вас ждет приятная атмосфера для отдыха и ожидания. И услуга для родителей – присмотр за детками старше трех лет.\n\n"
              "Вход с торца здания проката по лестнице.\n\n"
              "Ждем Вас)\n\n"
              "Контакты директора: \n",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () {
                callNumber(_phoneNumber);
              },
              child: Text(
                _phoneNumber,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: () {
                writeEmail("katyagolodiaeva@gmail.com");
              },
              child: const Text(
                "\nkatyagolodiaeva@gmail.com\n",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMainScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const MainScreen()),
        (route) => false);
  }
}
