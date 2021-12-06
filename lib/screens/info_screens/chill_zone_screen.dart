import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../extension.dart';
import '../main_screen.dart';

final List<String> imgList = [
  "assets/info_screens/chill_zone/chill_zone.jpg",
];

class ChillZoneScreen extends StatefulWidget {
  @override
  _ChillZoneScreenState createState() => _ChillZoneScreenState();
}

class _ChillZoneScreenState extends State<ChillZoneScreen> {
  int _current = 0;

  final String _phoneNumber = "89646546227";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: screenHeight,
      width: screenWidth,
      decoration: screenDecoration("assets/info_screens/chill_zone/bg.png"),
      child: Column(
        children: [
          _title(),
          _slider(),
          _description(),
          _button(context, "НА ГЛАВНУЮ")
        ],
      ),
    ));
  }

  Widget _title() {
    return Container(
        margin: EdgeInsets.only(top: screenHeight * 0.07),
        child: Text(
          "ЗОНА ОТДЫХА И ДЕТСКОГО ДОСУГА",
          style: TextStyle(
              fontSize: screenHeight * 0.024,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ));
  }

  Widget _slider() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            CarouselSlider(
              items: _getImagesForSlider(),
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.map((url) {
                int index = imgList.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ],
        ));
  }

  List<Widget> _getImagesForSlider() {
    return imgList
        .map(
          (item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Image.asset(item),
            ),
          ),
        )
        .toList();
  }

  Widget _description() {
    return Container(
        height: screenHeight * 0.42,
        width: screenWidth * 0.8,
        child: SingleChildScrollView(
            child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Дорогие гости!\n\n"
              "Приглашаем Вас отдохнуть на Второй этаж. Вас ждет приятная атмосфера для отдыха и ожидания.\n\n"
              "Для Вас услуги буфета и платной комфортабельной зоны отдыха для взрослых и детей: wi-fi, зона детского досуга, настольные игры для детей и взрослых, теплый туалет, массажер для ног, горячий шашлык и вкусные домашние колбаски от Коляна. Вас ждет приятная атмосфера для отдыха и ожидания. И услуга для родителей – присмотр за детками старше трех лет.\n\n"
              "Вход с торца здания проката по лестнице.\n\n"
              "Ждем Вас)\n\n"
              "Контакты директора: \n",
              style: TextStyle(fontSize: 12),
            ),
            GestureDetector(
              onTap: () {
                callNumber(_phoneNumber);
              },
              child: Text(_phoneNumber, style: TextStyle(fontSize: 12),),
            ),
            GestureDetector(
              onTap: () {
                writeEmail("katyagolodiaeva@gmail.com");
              },
              child: Text("\nkatyagolodiaeva@gmail.com\n", style: TextStyle(fontSize: 12),),
            ),
          ],
        )));
  }

  Widget _button(BuildContext context, String text) {
    return Container(
      width: screenWidth * 0.63,
      height: screenHeight * 0.08,
      margin: EdgeInsets.only(top: 20),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(35)),
        color: Colors.blue,
        child: InkWell(
            onTap: () => _openMainScreen(),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ]),
            )),
      ),
    );
  }

  void _openMainScreen() {
    Navigator.pop(context);
  }
}
