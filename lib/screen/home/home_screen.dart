import 'dart:ui';
import 'package:donation_nature/screen/home/disaster_list.dart';
import 'package:donation_nature/screen/home/info_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'api_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentPos = 0;
  String label = '';
  String background = 'assets/images/positive_background.png';
  List<bool>? disasterAtUserLocation = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  var i_images = List<String>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  Future<void> getWeatherData() async {
    // 유저가 위치한 지역의 기상 특보를 받아옴
    for (int i = 0; i < location.length; i++) {
      if (Static.userLocation!.contains(location[i])) {
        for (int j = 0; j < Static.reportList!.length; j++) {
          if (Static.reportList![j].contains(location[i])) {
            disasterAtUserLocation![j] = true;
          }
        }
      }
    }

    for (int i = 0; i < disasterAtUserLocation!.length; i++) {
      if (disasterAtUserLocation![i]) {
        i_images.add(images[i]);
        label += ' ' + labels[i];
      }
    }

    if (i_images.length == 0) {
      i_images.add('assets/images/earthh.png');
    }

    if (label == '') {
      label = ' 현재 발효된 특보가 없습니다';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy년 MM월 dd일 HH:mm");
    return Stack(children: <Widget>[
      Image.asset(background,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          colorBlendMode: BlendMode.modulate,
          color: Color.fromARGB(255, 161, 161, 161)),
      Scaffold(
        appBar: AppBar(
          title: Text("도네이처",
              style: TextStyle(
                color: Color.fromARGB(255, 59, 59, 59),
              )),
          // backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.transparent,
        body: Container(

            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     fit: BoxFit.fill,
            //     colorFilter: ColorFilter.mode(
            //         Color.fromARGB(255, 127, 127, 127), BlendMode.darken),
            //     image: AssetImage(background), // 배경 이미지
            //   ),
            // ),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: FadeInUp(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(
                        Icons.near_me,
                        color: Color.fromARGB(255, 224, 224, 224),
                      ),
                      Text(
                        Static.userLocation!,
                        style: TextStyle(
                          color: Color.fromARGB(255, 224, 224, 224),
                          fontSize: 27,
                          fontWeight: FontWeight.w200,
                        ),
                      )
                    ]),
                    SizedBox(height: 10),
                    Text(dateFormat.format(DateTime.now()),
                        style: TextStyle(
                            color: Color.fromARGB(255, 224, 224, 224),
                            fontWeight: FontWeight.w200)),
                    Text(
                        '기온 ${Static.wthrInfoList![0]} 습도 ${Static.wthrInfoList![1]}',
                        style: TextStyle(
                            color: Color.fromARGB(255, 224, 224, 224),
                            fontWeight: FontWeight.w200)),
                    SizedBox(height: 30),
                    CarouselSlider.builder(
                      itemCount: i_images.length,
                      options: CarouselOptions(
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentPos = index;
                            });
                          }),
                      itemBuilder: (context, itemIndex, realIndex) {
                        return Container(
                            child: Column(
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              // flex: 2,
                              child: Image.asset(
                                i_images[itemIndex],
                              ),
                            )
                          ],
                        ));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: i_images.map((url) {
                        int index = i_images.indexOf(url);
                        return Container(
                          width: 5.0,
                          height: 5.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 3.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPos == index
                                ? Color.fromARGB(255, 119, 125, 122)
                                : Color.fromARGB(255, 181, 189, 186),
                          ),
                        );
                      }).toList(),
                    ),
                    alertBox(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => InfoScreen()));
                      },
                      child: Text("대처법 알아보기 →"),
                      style: TextButton.styleFrom(
                        primary: Color.fromARGB(255, 224, 224, 224),
                      ),
                    ),
                  ],
                )))),
      )
    ]);
  }

  Widget alertBox() {
    return Container(
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.80,
        decoration: BoxDecoration(
          color: Color.fromARGB(173, 170, 170, 170).withOpacity(0.1),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.warning_amber,
                color: Color.fromARGB(255, 224, 224, 224),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Color.fromARGB(255, 224, 224, 224),
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              )
            ])));
  }
}
