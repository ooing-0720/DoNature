import 'package:flutter/material.dart';
import 'post_detail_screen.dart';
import 'package:donation_nature/board/domain/post.dart';

GestureDetector postListTile(BuildContext context, Post data) {
  List<String> tagMoreList = ['나눔하기', '나눔받기', '알리기'];
  return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(data),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          title: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff416E5C),
                          ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "${tagMoreList[data.share!]}",
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff416E5C),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        "${data.title}",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(
              top: 3.0,
              bottom: 3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.date!.toDate().toLocal().toString().substring(5, 16)}",
                  style: TextStyle(fontSize: 12),
                ),
                if (data.share == 0)
                  Row(
                    children: [
                      Text(
                        "나눔해요",
                        style: TextStyle(
                            color: Color(0xff416E5C),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${data.item}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${data.itemCnt}개",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                else if (data.share == 1)
                  Row(
                    children: [
                      Text(
                        "나눔받아요",
                        style: TextStyle(
                            color: Color(0xff416E5C),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${data.item}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${data.itemCnt}개",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                else
                  Container(),
                Row(children: [
                  Text(
                    "#${data.disaster}",
                    style: TextStyle(
                        color: Color(0xff416E5C), fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "#${data.locationSiDo}",
                    style: TextStyle(
                        color: Color(0xff416E5C), fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Builder(builder: (context) {
                    return data.isDone
                        ? Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3.0))),
                            child: Text(
                              "나눔완료",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          )
                        : Container();
                  }),
                ]),
              ],
            ),
          ),
        ),
      ));
}
