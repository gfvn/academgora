import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:academ_gora_release/core/data_keepers/price_keeper.dart';
import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';

import '../main_screen/main_screen.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  final PriceKeeper _priceKeeper = PriceKeeper();
  List<String> links = [];
  List<String> text = [];

  _PriceScreenState(){
    linkAndText();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Прайс"),
        centerTitle: true,
      ),
      body: Container(
        decoration: screenDecoration("assets/info_screens/prices/bg.png"),
        child: Container(
          margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top:0),
          child: Flex(
            direction: Axis.vertical,
            children: [
              _priceTitle(),
              _pricePriceInfo(),
              _table(),
              _info(),
              AcademButton(
                tittle: 'НА ГЛАВНУЮ',
                onTap: _openMainScreen,
                width: screenWidth*0.9,
                fontSize: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 5),
      child: const Text(
        "ПРАЙС",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _pricePriceInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Будни / ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            "Выходные и праздничные дни",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _table() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          buildTittle(),
          Table(
            border: TableBorder.all(color: Colors.white, width: 2),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: List.generate(
              _priceKeeper.listKeyPrice.length,
                  (index) => TableRow(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,top: 5.0,bottom: 5.0),
                    child: _customText(_priceKeeper.listKeyPrice[index].key),
                  ),
                  Table(
                    children: [
                      TableRow(
                        children: <Widget>[
                          _customTextTable(
                              _priceKeeper.listKeyPrice[index].price1,
                              _priceKeeper.listKeyPrice[index].price2),
                        ],
                      )
                    ],
                  ),
                  Table(
                    children: [
                      TableRow(
                        children: <Widget>[
                          _customTextTable(
                            _priceKeeper.listKeyPrice[index].price3,
                            _priceKeeper.listKeyPrice[index].price4,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTittle() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _customText('Наименование услуги'),
            _customText('1-й час'),
            _customText('Целый день'),
          ],
        ),
      ),
    );
  }
  Widget _customText(String text) => Padding(
    padding: const EdgeInsets.only(left: 20.0),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w800,
        fontSize: 13.5,
      ),
    ),
  );

  Widget _customTextTable(String text1, String text2) => Padding(
    padding: const EdgeInsets.only(left: 20.0),
    child: Row(
      children: [
        Text(
          text1,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
          ),
        ),
        const SizedBox(width: 5,),
        const Text(
          '/',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
          ),
        ),
        const SizedBox(width: 5,),
        Text(
          text2,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
          ),
        ),
      ],
    ),
  );


  Widget _info() {
    _priceKeeper.listParagraph.sort((a, b) {
      return (b.id?.toLowerCase().compareTo((a.id?.toLowerCase())!))!;
    });
    return Expanded(
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
          )),
    );
  }

  void linkAndText(){
    for(int i=0;i<_priceKeeper.listParagraph.length;i++){
      if(_priceKeeper.listParagraph[i].isLink == true){
        links.add(_priceKeeper.listParagraph[i].text!);
      }else{
        text.add(_priceKeeper.listParagraph[i].text!);
      }
    }
  }
  Widget buildLink(String link) => GestureDetector(
    onTap: () {
      launchURL(link);
    },
    child: Text(
      "$link \n",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    ),
  );

  Widget buildText(String text) =>Text(
    text,
    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  );

  void _openMainScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const MainScreen()),
        (route) => false);
  }
}
