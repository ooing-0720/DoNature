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
import 'weather_disaster_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _isPlaying = false;
  MainAction _mainAction = MainAction();
  String userLocation = "";
  String result = "";
  int currentPos = 0;
  String? temp = '';
  String label = ' 로딩중입니다';
  Future<List<String>>? myFuture;
  String background = 'assets/images/background_positive.jpg';
  List<String> WthrInfoList = ['', '', '', ''];
  List<String> reportList = ['', '', '', '', ''];
  List<bool>? disasterAtUserLocation = [false, false, false, false, false];
  bool loading = false;
  var i_images = List<String>.empty(growable: true);

  WthrReport wthrReport = WthrReport();

  @override
  void initState() {
    super.initState();
    getWeatherData();
    myFuture = wthrReport.getWeatherReport();
  }

  Future<void> getWeatherData() async {
    setState(() {
      loading = false;
    });

    WthrInfoList = await wthrReport.getWthrInfo();
    result = await _mainAction.getAddress();
    userLocation = result.replaceAll(RegExp('[대한민국0-9\-]'), '');

    // reportList = await wthrReport.getWeatherReport();

    // wthrReport.getWthrInfo().then((List<String> value) {
    //   setState(() {
    //     WthrInfoList = value;
    //   });
    // });

    // _mainAction.getAddress().then((String value) {
    //   setState(() {
    //     result = value;
    //     userLocation = result.replaceAll(RegExp('[대한민국0-9\-]'), '');
    //   });
    // });

    // wthrReport.getWeatherReport().then((List<String> value) {
    //   setState(() {
    //     reportList = value;
    //   });
    // });

    // userLocation = '서울특별시 강남구';
    // reportList = [
    //   '폭염주의보: 서울',
    //   // '${wthrWrnList?[0].FHWA} ${wthrWrnList?[0].HWA} ${wthrWrnList?[0].HWW}',
    //   '', '', '', '풍랑주의보: 서울'
    // ];

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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AlarmScreen()));
            },
            icon: Icon(Icons.notifications),
          )
        ],
        elevation: 0,
      ),
      body: loading
          ? Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(255, 127, 127, 127), BlendMode.darken),
                  image: AssetImage(background), // 배경 이미지
                ),
              ),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10)))
          : Container(
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
                              userLocation,
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
                      Text('기온 ${WthrInfoList[0]} 습도 ${WthrInfoList[1]}',
                          style: TextStyle(
                              color: Color.fromARGB(255, 181, 189, 186))),
                      SizedBox(height: 30),
                      FutureBuilder<List<String>>(
                        future: myFuture,
                        builder: (ctx, snapshot) {
                          if (snapshot.hasData) {
                            reportList = snapshot.data!;
                            for (int i = 0; i < location.length; i++) {
                              if (userLocation.contains(location[i])) {
                                for (int j = 0; j < reportList.length; j++) {
                                  if (reportList[j].contains(location[i])) {
                                    disasterAtUserLocation![j] = true;
                                  }
                                }
                              }
                            }

                            for (int i = 0;
                                i < disasterAtUserLocation!.length;
                                i++) {
                              if (disasterAtUserLocation![i]) {
                                i_images.add(images[i]);
                                label += ' ' + labels[i];
                              }
                            }
                            if (i_images.length == 0) {
                              i_images.add('assets/images/earth.png');
                            }
                            if (label == ' 로딩중입니다') {
                              label = ' 현재 발효된 특보가 없습니다';
                            }
                            return CarouselSlider.builder(
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
                                    width: 200,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 3.0),

                                    // decoration: BoxDecoration(
                                    //   color: Colors.wh,
                                    // ),

                                    child: Column(
                                      children: [
                                        Image.asset(i_images[itemIndex],
                                            fit: BoxFit.fill),

                                        // Text(labels[itemIndex])
                                      ],
                                    ));
                              },
                            );
                          } else if (snapshot.hasError) {
                            setState() {
                              label = '예기치 못한 에러가 발생했습니다.';
                            }

                            return Image.asset('assets/images/loading.png',
                                width: 50, height: 50);
                          } else {
                            return CircularProgressIndicator();
                          }
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
                                vertical: 5.0, horizontal: 2.0),
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
      ]),
    );
  }
}
