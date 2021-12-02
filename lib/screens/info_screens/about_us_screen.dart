import 'package:academ_gora_release/screens/all_instructors/all_instructors_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../extension.dart';
import '../main_screen.dart';

final List<String> imgList = [
  "assets/info_screens/about_us/0.jpg",
  "assets/info_screens/about_us/1.jpg",
  "assets/info_screens/about_us/2.jpg",
  "assets/info_screens/about_us/3.jpg",
  "assets/info_screens/about_us/4.jpg",
];

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: screenDecoration("assets/info_screens/about_us/bg.png"),
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                _title(),
                _slider(),
                _description(),
                defaultButton('НАШИ ИНСТРУКТОРЫ', _openInstructorsScreen,
                    width: 280),
                defaultButton('НА ГЛАВНУЮ', _openMainScreen, width: 280),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: const Text(
        "СК \"АКАДЕМИЧЕСКИЙ\"",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
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
    return Expanded(
        child: SingleChildScrollView(
            child: Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "На базе работает три подъемника – кресельный и два веревочных. Четыре трассы для катания. \n\n"
          "Лесная трасса для беговых лыж, ближайшее место проката беговых лыж находится в ледовом дворце «Айсберг» - спортивно-экипировочный центр «ЮниорСпорт».\n\n"
          "На нашей горнолыжной базе вы можете взять в аренду горные лыжи от 24 до 46 размера ноги, сноуборды от 30 до 46 размера ноги\n\n"
          "Имеются квалифицированные инструкторы для индивидуальных и групповых занятий по горным лыжам и сноуборду для детей и взрослых.\n\n"
          "На втором этаже здания проката есть буфет, комфортабельная комната отдыха и ожидания для взрослых и зона детского досуга; по выходным и праздникам Колян готовит вкусные шашлыки;\n\n"
          "Также есть детская школа горных лыж «Вершина» от 3,5 до 8 лет – информацию и контакты вы можете найти в инстаграмме \n\n«Вершина горнолыжный клуб» -",
          style: TextStyle(fontSize: 12),
        ),
        GestureDetector(
            onTap: () {
              launchURL(
                  "https://instagram.com/vershina_skiclub?igshid=10c5vgh9rlsew");
            },
            child: const Text(
              "https://instagram.com/vershina_skiclub?igshid=10c5vgh9rlsew\n",
              style: TextStyle(fontSize: 12),
            )),
        Row(
          children: [
            const Text(
              "или по телефону ",
              style: TextStyle(fontSize: 12),
            ),
            phoneNumberForCallWidget(
              "89025664248 ",
              textStyle: TextStyle(fontSize: 12),
            ),
            const Text(
              "Наталья",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        const Text(
          "\nШкола сноуборда для детей и взрослых «Байкальское солнце» - информация в инстаграмме «ирк сноуборд» или «сноуборд иркутск» - \n",
          style: TextStyle(fontSize: 12),
        ),
        GestureDetector(
            onTap: () {
              launchURL(
                  "https://instagram.com/irk_snowboard?igshid=1x8vatsggr7mu");
            },
            child: const Text(
              "https://instagram.com/irk_snowboard?igshid=1x8vatsggr7mu\n",
              style: TextStyle(fontSize: 12),
            )),
        Row(
          children: [
            const Text(
              "а также по телефону – ",
              style: TextStyle(fontSize: 12),
            ),
            phoneNumberForCallWidget(
              "89041405551 ",
              textStyle: TextStyle(fontSize: 12),
            ),
            const Text(
              "Екатерина",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        const Text(
          "\nВъезд на парковку платный – 100 рублей. ",
          style: TextStyle(fontSize: 12),
        )
      ],
    )));
  }

  void _openMainScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const MainScreen()),
        (route) => false);
  }

  void _openInstructorsScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (c) => AllInstructorsScreen()));
  }
}
