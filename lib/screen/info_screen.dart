import 'package:donation_nature/API/domain/ultra_srt_ncst.dart';
import 'package:donation_nature/API/repository/ultra_srt_ncst_repository.dart';
import 'package:donation_nature/API/repository/wthr_wrn_liist_repository.dart';
import 'package:donation_nature/action/action.dart';
import 'package:donation_nature/permission/permission_request.dart';
import 'package:donation_nature/screen/alarm_screen.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  void _callAPI() async {
    PermissionRequest.determinePosition();

    UltraSrtNcstRepository ultraSrtNcstRepository = UltraSrtNcstRepository();
    UltraSrtNcst? ultraSrtNcst =
        await ultraSrtNcstRepository.loadUltraSrtNcst();

    print(
        "기온 : ${ultraSrtNcst?.T1H}, 1시간 강수량 : ${ultraSrtNcst?.RN1}, 습도 : ${ultraSrtNcst?.REH}, 강수형태 : ${ultraSrtNcst?.PTY}");

    WthrWrnListRepository wthrWrnListRepository = WthrWrnListRepository();
    var wthrWrnList = await wthrWrnListRepository.loadWthrWrnList();

    print(
        "폭염 예비특보: ${wthrWrnList?[0].FHWA}\n호우 예비특보: ${wthrWrnList?[0].FHRA}\n태풍 예비특보: ${wthrWrnList?[0].FTYA}\n강풍 예비특보: ${wthrWrnList?[0].FSWA}\n풍랑 예비특보: ${wthrWrnList?[0].FSTA}");

    print(
        "폭염주의보: ${wthrWrnList?[0].HWA}\n폭염경보: ${wthrWrnList?[0].HWW}\n호우주의보: ${wthrWrnList?[0].HRA}\n호우경보: ${wthrWrnList?[0].HRW}\n태풍주의보: ${wthrWrnList?[0].TYA}\n강풍주의보: ${wthrWrnList?[0].SWA}\n풍랑주의보: ${wthrWrnList?[0].STA}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('재난 정보',
            style: TextStyle(
              color: Colors.black,
            )),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AlarmScreen()));
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _callAPI,
          child: const Text('Call API'),
        ),
      ),
    );
  }
}
