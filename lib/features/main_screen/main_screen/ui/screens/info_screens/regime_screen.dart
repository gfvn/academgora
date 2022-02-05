import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/ui/screens/main_screen/main_screen.dart';
import 'package:academ_gora_release/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = [
  "assets/info_screens/about_us/0.jpg",
];

class RegimeScreen extends StatefulWidget {
  const RegimeScreen({Key? key}) : super(key: key);

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
        appBar: AppBar(
          title: const Text(
            "РЕЖИМ РАБОТЫ И СХЕМА ПРОЕЗДА",
            style: TextStyle(fontSize: 14),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: screenDecoration("assets/info_screens/about_us/bg.png"),
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
        ));
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
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Image.asset(
              item,
            ),
          ),
        )
        .toList();
  }

  Widget _description() {
    return Container(
      padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
      height: screenHeight * 0.5,
      child: SingleChildScrollView(
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          children: [
            const Text(
              "Мы находимся по адресу – ул. Фаворского 1 Б, остановка общественного транспорта «Госуниверситет» или «Мегаполис», 100 м от улицы Улан-Баторская. В 2гис нас можно найти как «спортивный комплекс Академический» - \n",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () {
                launchURL("https://go.2gis.com/junny");
              },
              child: const Text(
                "https://go.2gis.com/junny.\n",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const Text(
              "Мы в социальных сетях инстаграмм и вконтакте – горнолыжка в академе! \n",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () {
                launchURL("https://vk.com/akademgora");
              },
              child: const Text(
                "https://vk.com/akademgora\n",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: () {
                launchURL("https://www.instagram.com/akademgora/");
              },
              child: const Text(
                "https://www.instagram.com/akademgora/\n\n",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
