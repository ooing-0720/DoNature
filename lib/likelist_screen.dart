import 'package:flutter/material.dart';

class LikelistScreen extends StatefulWidget {
  const LikelistScreen({Key? key}) : super(key: key);

  @override
  _LikeListViewState createState() => _LikeListViewState();
}

class _LikeListViewState extends State<LikelistScreen> {
  var title = ['oo시 oo구 침수 피해', 'oo군 가뭄 피해'];
  var nickname = ['김민지', '김민수'];
  List<IconData> icons = [
    // 이렇게 하는게 맞나싶다
    Icons.favorite,
    Icons.favorite,
  ];
  bool alreadySaved = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('관심목룩',
              style: TextStyle(
                color: Colors.black,
              )),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications),
            ),
          ],
        ),
        body: ListView.separated(
          itemCount: title.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(title[index]),
              subtitle: Text(nickname[index]),
              trailing: IconButton(
                icon: Icon(icons[index]),
                color: Color(0xff9fc3a8),
                onPressed: () {
                  setState(() {
                    if (icons[index] == Icons.favorite)
                      icons[index] = Icons.favorite_border;
                    else
                      icons[index] = Icons.favorite;
                  });
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(thickness: 1);
          },
          shrinkWrap: true,
        ));
  }
}
