import 'package:donation_nature/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/screen/mypage/likelist_screen.dart';
import 'package:donation_nature/screen/mypage/activitylist_screen.dart';
import 'package:donation_nature/screen/user_manage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';

class MyPageHeader extends StatefulWidget {
  const MyPageHeader({Key? key}) : super(key: key);

  @override
  State<MyPageHeader> createState() => MyPageHeaderState();
}

class MyPageHeaderState extends State<MyPageHeader> {
  final UserManage userManage = UserManage();
  String userName = '';
  String userEmail = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
      ),
      padding: EdgeInsets.all(20), child: buildMypageHeader(context),
      // _buildMypageMenu(context),
    );
  }

  Widget buildMypageHeader(BuildContext context) {
    User? user = userManage.getUser();

    if (user == null) {
      userName = "로그인하세요";
      userEmail = '';
    } else {
      userName = user.displayName! + '님';
      userEmail = user.email!;
    }

    return Container(
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
        ),
        child: Column(children: [
          Row(children: [
            CircleAvatar(
              backgroundColor: Color.fromARGB(221, 223, 223, 223),
              backgroundImage: AssetImage('assets/images/default_profile.png'),
              radius: 30.0,
            ),
            SizedBox(width: 30),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 15),
              if (user == null) ...[
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '로그인',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                        ),
                        TextSpan(
                            text: '하세요',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            )),
                      ]),
                    )),
              ] else ...[
                Text(
                  userName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                )
              ],
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xffE4EFE7),
                ),
                child: Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              SizedBox(height: 30),
            ])
          ]),
          Row(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivitylistScreen()));
                },
                child: _buildMypageMenuItem(Icons.view_list, "활동내역"),
              ),
              VerticalDivider(thickness: 2, color: Colors.grey),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LikelistScreen()));
                },
                child: _buildMypageMenuItem(Icons.favorite, "관심목록"),
              )
            ],
          ),
        ]));
  }

  Widget _buildMypageMenuItem(IconData mIcon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          // decoration: BoxDecoration(
          //     border: Border.all(
          //       color: Color(0xffbadc58),
          //       width: 2,
          //     ),
          //     borderRadius: BorderRadius.circular(30)),
          child: Icon(
            mIcon,
            color: Color(0xffE4EFE7),
            size: 30,
          ),
        ),
        SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 20))
      ],
    );
  }

  // Widget _buildMypageMenu(BuildContext context) {
  //   return Container(
  //     margin: EdgeInsets.all(20),
  //     child: Row(
  //       //mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         InkWell(
  //           onTap: () {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => ActivitylistScreen()));
  //           },
  //           child: _buildMypageMenuItem(Icons.view_list, "활동내역"),
  //         ),
  //         InkWell(
  //           onTap: () {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => LikelistScreen()));
  //           },
  //           child: _buildMypageMenuItem(Icons.favorite, "관심목록"),
  //         ),
  //         InkWell(
  //           onTap: () {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => CertifyScreen()));
  //           },
  //           child: _buildMypageMenuItem(Icons.badge, "기관인증"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
