import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:academ_gora_release/core/functions/functions.dart';
import 'package:academ_gora_release/main.dart';
import 'package:academ_gora_release/screens/profile/administrator_profile/instructors_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

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
      // ignore: prefer_const_literals_to_create_immutables
      appBar: AppBar(
        title: const Text("СК \"АКАДЕМИЧЕСКИЙ\""),
        centerTitle: true,
      ),
      body: Container(
        decoration: screenDecoration("assets/info_screens/about_us/bg.png"),
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                _slider(),
                _description(),
                AcademButton(
                  tittle: 'НАШИ ИНСТРУКТОРЫ',
                  onTap: () {
                    FunctionsConsts.openPushScreen(
                        context, const InstructorsScreen());
                  },
                  width: screenWidth * 0.9,
                  fontSize: 18,
                ),
              ],
            ),
          ),
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
            child: Image.asset(
              item,
            ),
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
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            GestureDetector(
                onTap: () {
                  launchURL(
                      "https://instagram.com/vershina_skiclub?igshid=10c5vgh9rlsew");
                },
                child: const Text(
                  "https://instagram.com/vershina_skiclub?igshid=10c5vgh9rlsew\n",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )),
            Row(
              children: [
                const Text(
                  "или по телефону ",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                phoneNumberForCallWidget(
                  "89025664248 ",
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Наталья",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                )
              ],
            ),
            const Text(
              "\nШкола сноуборда для детей и взрослых «Байкальское солнце» - информация в инстаграмме «ирк сноуборд» или «сноуборд иркутск» - \n",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            GestureDetector(
                onTap: () {
                  launchURL(
                      "https://instagram.com/irk.board?utm_medium=copy_link");
                },
                child: const Text(
                  "https://instagram.com/irk.board?utm_medium=copy_link\n",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )),
            Row(
              children: [
                const Text(
                  "а также по телефону – ",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                phoneNumberForCallWidget(
                  "89041405551 ",
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Екатерина",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                )
              ],
            ),
            const Text(
              "\nВъезд на парковку платный – 100 рублей. ",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
