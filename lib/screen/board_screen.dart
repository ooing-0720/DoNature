import 'package:flutter/material.dart';
import './post/post_add_screen.dart';
import './post/post_detail_screen.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({Key? key}) : super(key: key);

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("나눔게시판"),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(),
                );
              },
              icon: Icon(Icons.search)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(index), //0,1,2,3..
                  ));
            },
            //사진 첨부시 썸네일
            title: Text("제목1"),
            subtitle: Text("본문1"),
            leading: Icon(Icons.abc),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text("$index")],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PostAddScreen()));
        },
        label: Text('글쓰기'),
        backgroundColor: Color.fromARGB(255, 7, 65, 29),
        icon: Icon(Icons.add),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  MySearchDelegate()
      : super(
            searchFieldLabel: "검색",
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      //검색어 지우는 기능
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //뒤로가기
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => const Text('suggestions');
  //검색결과 보여줌
  @override
  Widget buildResults(BuildContext context) => const Text('results');
}
