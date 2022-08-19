import 'package:flutter/material.dart';

class ActivitylistScreen extends StatelessWidget {
  const ActivitylistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = ['oo시 oo구 침수 피해', 'oo군 가뭄 피해'];
    var nickname = ['홍길동', '홍길동'];
    return Scaffold(
        appBar: AppBar(
          title: Text('활동내역',
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
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(thickness: 1);
          },
          shrinkWrap: true,
        ));
  }
}
