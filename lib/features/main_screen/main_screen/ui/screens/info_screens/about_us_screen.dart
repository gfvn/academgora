import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:academ_gora_release/core/data_keepers/about_us_keeper.dart';
import 'package:academ_gora_release/core/data_keepers/chill_zone_keeper.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/chill_zone.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/news.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/ui/screens/main_screen/main_screen.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/ui/screens/main_screen/widgets/image_view_widget.dart';
import 'package:academ_gora_release/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = [
  "assets/info_screens/chill_zone/chill_zone.jpg",
];

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUsScreen> {
  int _current = 0;
  final AboutUsKeeper _aboutUsKeeper = AboutUsKeeper();
  List<String> imageUrls = [];
  bool isLoading = false;
  List<Widget> imageSliders = [];
  List newsList = [];
  List<String> links = [];
  List<String> text = [];

  _AboutUsState(){
    linkAndText();
  }


  void _getNews() async {
    setState(
          () {
        isLoading = true;
      },
    );
    newsList = _aboutUsKeeper.about;
    imageUrls = _aboutUsKeeper.aboutUsUrl;
    createSliderWidget();
    setState(
          () {
        isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _getNews();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "СК \"АКАДЕМИЧЕСКИЙ\"",
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
            items: imageSliders,
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
            children: newsList.map(
                  (url) {
                int index;
                if (url != null) {
                  index = int.parse(url['Место'].toString());
                  print(index);
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
                }

                return const SizedBox();
              },
            ).toList(),
          ),
        ],
      ),
    );
  }




  void createSliderWidget() async {
    for (String news in imageUrls) {
      String url = news;
      imageSliders.add(
        ImageViewWidget(
          imageUrl: url.toString(),
          assetPath: "assets/main/10_pic${imageUrls.indexOf(news) + 1}.png",
        ),
      );
    }
  }


  Widget _description() {
    _aboutUsKeeper.listAboutUs.sort((a, b) {
      return (b.id?.toLowerCase().compareTo((a.id?.toLowerCase())!))!;
    });
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
      height: screenHeight * 0.5,
      child: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context,index) => buildText(text[index]),
              separatorBuilder: (context,index) => const SizedBox(height: 10,),
              itemCount: text.length,
            ),
            const SizedBox(height: 10,),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context,index) => buildLink(links[index]),
              separatorBuilder: (context,index) => const SizedBox(height: 10,),
              itemCount: links.length,
            ),
          ],
        ),
      ),
    );
  }



  void linkAndText(){
    for(int i=0;i<_aboutUsKeeper.listAboutUs.length;i++){
      if(_aboutUsKeeper.listAboutUs[i].isLink == true){
        links.add(_aboutUsKeeper.listAboutUs[i].text!);
      }else{
        text.add(_aboutUsKeeper.listAboutUs[i].text!);
      }
    }
  }

  Widget buildText(String text) =>Text(
    text,
    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  );
  Widget buildLink(String link) => GestureDetector(
    onTap: () {
      launchURL(link);
    },
    child: Text(
      "$link \n",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    ),
  );

  void _openMainScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const MainScreen()),
            (route) => false);
  }

}
