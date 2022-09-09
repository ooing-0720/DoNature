import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './post/post_add_screen.dart';
import './post/post_detail_screen.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/user_manage.dart';

GestureDetector postListTile(BuildContext context, Post data) {
  return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(data),
            ));
      },
      child: ListTile(
        title: Text(
          "${data.title}",
          style: TextStyle(fontSize: 17.5),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${data.date!.toDate().toLocal().toString().substring(5, 16)}",
              style: TextStyle(fontSize: 12),
            ),
            Row(children: [
              Transform(
                transform: new Matrix4.identity()..scale(0.95),
                child: Row(
                  children: [
                    Chip(
                      label: Text(
                        "${data.tagMore}",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(0xff90B1A4),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Chip(
                      label: Text(
                        "${data.tagDisaster}",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(0xff90B1A4),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Chip(
                      label: Text(
                        "${data.locationSiDo}",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(0xff90B1A4),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Builder(builder: (context) {
                return data.isDone
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            "나눔완료",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      )
                    : Container();
              }),
            ]),
          ],
        ),
        // trailing: IconButton(
        //   icon: Icon(
        //     PostService().isLiked(data, user)
        //         ? Icons.favorite
        //         : Icons.favorite_border,
        //     color: Color(0xff5B7B6E),
        //   ),
        //   onPressed: () {
        //     setState(() {
        //       PostService().likePost(data, user);
        //       PostService().isLiked(data, user)
        //           ? ScaffoldMessenger.of(context)
        //               .showSnackBar(SnackBar(
        //                   content:
        //                       Text("관심 목록에 추가되었습니다.")))
        //           : ScaffoldMessenger.of(context)
        //               .showSnackBar(SnackBar(
        //                   content: Text("관심글 취소")));
      ));
}
