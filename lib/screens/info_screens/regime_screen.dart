import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../core/consants/extension.dart';
import '../main_screen.dart';

final List<String> imgList = [
  "assets/info_screens/about_us/0.jpg",
];

class RegimeScreen extends StatefulWidget {
  @override
  _RegimeScreenState createState() => _RegimeScreenState();
}

class _RegimeScreenState extends State<RegimeScreen> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: screenHeight,
      width: screenWidth,
      decoration: screenDecoration("assets/info_screens/about_us/bg.png"),
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
          "РЕЖИМ РАБОТЫ И СХЕМА ПРОЕЗДА",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          children: [
            Text(
              "Мы находимся по адресу – ул. Фаворского 1 Б, остановка общественного транспорта «Госуниверситет» или «Мегаполис», 100 м от улицы Улан-Баторская. В 2гис нас можно найти как «спортивный комплекс Академический» - \n",
              style: TextStyle(fontSize: 12),
            ),
            GestureDetector(
              onTap: () {
                launchURL("https://go.2gis.com/junny");
              },
              child: Text(
                "https://go.2gis.com/junny.\n",
                style: TextStyle(fontSize: 12),
              ),
            ),
            Text(
              "Мы в социальных сетях инстаграмм и вконтакте – горнолыжка в академе! \n",
              style: TextStyle(fontSize: 12),
            ),
            GestureDetector(
              onTap: () {
                launchURL("https://vk.com/akademgora");
              },
              child: Text(
                "https://vk.com/akademgora\n",
                style: TextStyle(fontSize: 12),
              ),
            ),
            GestureDetector(
              onTap: () {
                launchURL("https://www.instagram.com/akademgora/");
              },
              child: const Text(
                "https://www.instagram.com/akademgora/\n\n",
                style: TextStyle(fontSize: 12),
              ),
            ),
            const Text(
              "Понедельник – выходной\n"
              "Со вторника по пятницу работаем с 10:00 до 21:00\n"
              "В выходные, а также праздничные дни работаем с 10:00 до 21:00, обратите внимание, что с 14:00 до 15:00 прокат закрывается на санитарную обработку, получить или сдать арендованный инвентарь в этот период не получится. "
              "Для приобретения билетов на подъемник есть отдельное окно со стороны улицы.\n"
              "\n\n"
              "* в будни с 19:00 до 21:00 - время проведения занятий спортивных школ: на склоне будут установлены вешки, большая очередь на подъемник. НЕРЕКОМЕНДОВАННОЕ ВРЕМЯ ДЛЯ ПОСЕЩЕНИЯ. \n\n"
              "Работа кресельного подъемника ограничена понижением температуры ниже -23 гр. Цельсия и скоростью ветра более 15 м/с. "
              "Актуальную информацию при таких погодных условиях вы можете уточнить в инстаграмме «горнолыжка в академе»\n",
              style: TextStyle(fontSize: 12),
            ),
            GestureDetector(
              onTap: () {
                launchURL("https://www.instagram.com/akademgora/");
              },
              child: const Text(
                "https://www.instagram.com/akademgora/",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
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
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const MainScreen()),
        (route) => false);
  }
}
