import 'dart:ui';
import 'package:donation_nature/action/action.dart';
import 'package:donation_nature/screen/disaster_list.dart';
import 'package:donation_nature/screen/info_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:donation_nature/screen/alarm_screen.dart';
import 'api_info.dart';
import 'weather_disaster_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentPos = 0;

  String label = '';

  String background = 'assets/images/background_default.jpg';

  List<bool>? disasterAtUserLocation = [false, false, false, false, false];
  bool loading = true;
  var i_images = List<String>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  Future<void> getWeatherData() async {
    setState(() {
      loading = true;
    });

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
      i_images.add('assets/images/earth.png');
    }
    if (label == '') {
      label = ' 현재 발효된 특보가 없습니다';
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy년 MM월 dd일 HH:mm");
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("DONATURE"),
        elevation: 0,
      ),
      body:
          // loading
          //     ? Container(
          //         decoration: BoxDecoration(
          //           image: DecorationImage(
          //             fit: BoxFit.cover,
          //             colorFilter: ColorFilter.mode(
          //                 Color.fromARGB(255, 127, 127, 127), BlendMode.darken),
          //             image: AssetImage(background), // 배경 이미지
          //           ),
          //         ),
          //         child: BackdropFilter(
          //             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10))):
          Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(255, 127, 127, 127), BlendMode.darken),
                  image: AssetImage(background), // 배경 이미지
                ),
              ),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: FadeInUp(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.near_me,
                              color: Color.fromARGB(255, 149, 182, 169),
                            ),
                            Text(
                              Static.userLocation!,
                              style: TextStyle(
                                color: Color.fromARGB(255, 181, 189, 186),
                                fontSize: 22,
                                fontWeight: FontWeight.w300,
                              ),
                            )
                          ]),
                      SizedBox(height: 10),
                      Text(dateFormat.format(DateTime.now()),
                          style: TextStyle(
                              color: Color.fromARGB(255, 181, 189, 186))),
                      Text(
                          '기온 ${Static.wthrInfoList![0]} 습도 ${Static.wthrInfoList![1]}',
                          style: TextStyle(
                              color: Color.fromARGB(255, 181, 189, 186))),
                      SizedBox(height: 30),
                      CarouselSlider.builder(
                        itemCount: i_images.length,
                        options: CarouselOptions(
                            viewportFraction: 1,
                            // autoPlay: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentPos = index;
                                // background = background_images[index];
                              });
                            }),
                        itemBuilder: (context, itemIndex, realIndex) {
                          return Container(
                              decoration: BoxDecoration(
                                  // color: Color.fromARGB(173, 170, 170, 170)
                                  //     .withOpacity(0.5),
                                  // borderRadius: BorderRadius.all(
                                  //   Radius.circular(10),
                                  // )
                                  // image: DecorationImage(
                                  //   fit: BoxFit.cover,
                                  //   image: AssetImage(
                                  //       'assets/images/background_drought.jpg'), // 배경 이미지
                                  // ),
                                  ),
                              // width: 200,
                              // margin: EdgeInsets.symmetric(horizontal: 1.0),

                              // decoration: BoxDecoration(
                              //   color: Colors.wh,
                              // ),

                              child: Column(
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Image.asset(i_images[itemIndex],
                                        fit: BoxFit.fill),
                                  )

                                  // Text(labels[itemIndex])
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
                          primary: Color.fromARGB(255, 181, 189, 186),
                          // primary: Color.fromARGB(255, 65, 110, 92), // foreground
                        ),
                      ),
                    ],
                  )))),
    );
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
                color: Color.fromARGB(255, 149, 182, 169),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Color.fromARGB(255, 181, 189, 186),
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              )
            ])
            // Flexible(
            //     child: RichText(
            //         overflow: TextOverflow.ellipsis,
            //         maxLines: 1,
            //         text: TextSpan(
            //           text: label,
            //           style: TextStyle(
            //             color: Color.fromARGB(255, 181, 189, 186),
            //             fontSize: 20,
            //             fontWeight: FontWeight.w300,
            //           ),
            //         )))
            ));
  }
}
