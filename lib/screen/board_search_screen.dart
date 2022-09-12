import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:donation_nature/board/service/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './post/post_detail_screen.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/user_manage.dart';
import 'package:donation_nature/screen/disaster_list.dart';
import 'package:donation_nature/screen/location_list.dart';
import './postListTile.dart';

class BoardSearchScreen extends StatefulWidget {
  const BoardSearchScreen({Key? key}) : super(key: key);

  @override
  State<BoardSearchScreen> createState() => _BoardSearchScreenState();
}

class _BoardSearchScreenState extends State<BoardSearchScreen> {
  List<String> tagMoreList = ['나눔하기', '나눔받기', '알리기'];
  List<String> locationGuList = [];
  String? _selectedDo = null;
  String? _selectedGu = null;
  int selectedDisasterIndex = -1;
  int selectedTagIndex = -1;
  GlobalKey _searchKey = GlobalKey();
  String? tagDisaster = null;
  String? tagMore = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("검색")),
        body: Builder(
          builder: (context) {
            bool visibility = false;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      searchTag(),
                      searchLocation(),
                      searchDisaster(),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xff416E5C)),
                            key: _searchKey,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => SearchResultScreen(
                                          _selectedDo,
                                          _selectedGu,
                                          tagDisaster,
                                          tagMore))));
                              //
                            },
                            child: Text("검색")),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }

  ExpansionTile searchTag() {
    return ExpansionTile(
      title: Container(
        child: Text(
          "글 종류로 검색하기 ",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),

      children: [
        Wrap(
          spacing: 12,
          children: List<Widget>.generate(
            tagMoreList.length,
            (int index) {
              return ChoiceChip(
                backgroundColor: Color(0xff416E5C),
                selectedColor: Colors.grey.withOpacity(0.5),
                label: Text(
                  tagMoreList[index],
                  style: TextStyle(color: Colors.white),
                ),
                selected: selectedTagIndex == index,
                onSelected: (bool selected) {
                  setState(() {
                    selectedTagIndex = selected ? index : -1;
                    tagMore = selected ? tagMoreList[index] : null;
                  });
                },
              );
            },
          ).toList(),
        ),
      ],
      //     ),
      //   ),
      // ),
    );
  }

  ExpansionTile searchDisaster() {
    return ExpansionTile(
      title: Container(
        child: Text(
          "재난 태그로 검색하기 ",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),

      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: disasterChips()),
        ),
      ],
      //     ),
      //   ),
      // ),
    );
  }

  ExpansionTile searchLocation() {
    return ExpansionTile(
      title: Container(
        child: Text(
          "위치 태그로 검색하기 ",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: locationDropdown(),
        ),
      ],
    );
  }

  List<Widget> disasterChips() {
    //null값 넣을 수 있게
    List<Widget> chips = [];

    for (int i = 0; i < disasterList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: ChoiceChip(
          backgroundColor: Color(0xff416E5C),
          selectedColor: Colors.grey.withOpacity(0.5),
          selected: selectedDisasterIndex == i,
          onSelected: (bool value) {
            setState(() {
              //selectedIndex = i;
              selectedDisasterIndex = value ? i : -1;
              tagDisaster = value ? disasterList[selectedDisasterIndex] : null;
            });
          },
          label: Text(
            disasterList[i],
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  Row locationDropdown() {
    return Row(
      children: [
        Container(
          width: 100,
          child: DropdownButton(
            hint: Text("시/도"),
            value: _selectedDo,
            isExpanded: true,
            items: locationDoList.map((String value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
            onChanged: (dynamic value) {
              if (value == '서울') {
                locationGuList = locationGuSeoulList;
              } else if (value == '부산') {
                locationGuList = locationGuBusanList;
              } else if (value == '대구') {
                locationGuList = locationGuDaeguList;
              } else if (value == '인천') {
                locationGuList = locationGuIncheonList;
              } else if (value == '광주') {
                locationGuList = locationGuGwangjuList;
              } else if (value == '대전') {
                locationGuList = locationGuDaejeonList;
              } else if (value == '울산') {
                locationGuList = locationGuUlsanList;
              } else if (value == '세종') {
                locationGuList = locationGuSejongList;
                //전체로만
              } else if (value == '경기') {
                locationGuList = locationSiGyeonggiList;
              } else if (value == '강원') {
                locationGuList = locationSiGangwonList;
              } else if (value == '충북') {
                locationGuList = locationSiChungbukList;
              } else if (value == '충남') {
                locationGuList = locationSiChungnamList;
              } else if (value == '전북') {
                locationGuList = locationSiJeonbukList;
              } else if (value == '전남') {
                locationGuList = locationSiJeonnamList;
              } else if (value == '경북') {
                locationGuList = locationSiGyeongbukList;
              } else if (value == '경남') {
                locationGuList = locationSiGyeongnamList;
              } else if (value == '제주') {
                locationGuList = locationSiJejuList;
              }
              setState(() {
                _selectedDo = value;
                _selectedGu = null;
              });
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 100,
          child: DropdownButton(
            hint: Text("구/군/시"),
            value: _selectedGu,
            isExpanded: true,
            items: locationGuList.map((String value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
            onChanged: (dynamic value) {
              setState(() {
                _selectedGu = value;
              });
            },
          ),
        ),
      ],
    );
  }
}

class SearchResultScreen extends StatefulWidget {
  String? _selectedDo;
  String? _selectedGu;
  String? tagDisaster;
  String? tagMore;
  SearchResultScreen(
      this._selectedDo, this._selectedGu, this.tagDisaster, this.tagMore);
  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return RefreshIndicator(
            child: FutureBuilder<List<Post>>(
                future: PostService().selectPostsByTag(widget._selectedDo,
                    widget._selectedGu, widget.tagDisaster, widget.tagMore),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Post> findPosts = snapshot.data!;

                    return ListView.separated(
                      itemCount: findPosts.length,
                      itemBuilder: (BuildContext context, int index) {
                        Post data = findPosts[index];

                        return postListTile(context, data);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(thickness: 1);
                      },
                    );
                  } else if (snapshot.hasError) {
                    print('${snapshot.error}');
                    return Text('${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            onRefresh: () {
              return Future(() {
                setState(() {});
              });
            });
      }),
    );
  }
}
