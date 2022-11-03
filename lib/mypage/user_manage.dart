import 'package:donation_nature/mypage/login_platform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserManage {
  static LoginPlatform? loginPlatform;

  void setLoginPlatForm(LoginPlatform sloginPlatform) {
    loginPlatform = sloginPlatform;
  }

  // void signOut() async {
  //   switch (loginPlatform!) {
  //     case LoginPlatform.facebook:
  //       break;
  //     case LoginPlatform.google:
  //       await GoogleSignIn().signOut();
  //       break;
  //     case LoginPlatform.email:
  //       await FirebaseAuth.instance.signOut();
  //       break;
  //     // case LoginPlatform.kakao:
  //     //   break;
  //     // case LoginPlatform.naver:
  //     //   break;
  //     // case LoginPlatform.apple:
  //     //   break;
  //     case LoginPlatform.none:
  //       break;
  //   }
  // }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    // final facebookLogin = FacebookLogin();
    await googleSignIn.signOut();
    // await facebookLogin.logOut();
    await FirebaseAuth.instance.signOut();
  }

  /// 회원가입, 로그인시 사용자 영속
  void authPersistence() async {
    await FirebaseAuth.instance.setPersistence(Persistence.NONE);
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');
    }
  }

  /// 유저 삭제
  Future<void> deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.delete();
  }

  /// 현재 유저 정보 조회
  User? getUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final nickname = user.displayName;
      final email = user.email;
      final uid = user.uid;
    }
    return user;
  }

  /// 공급자로부터 유저 정보 조회
  User? getUserFromSocial() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (final providerProfile in user.providerData) {
        final provider = providerProfile.providerId;
        final uid = providerProfile.uid;
        final name = providerProfile.displayName;
        final emailAddress = providerProfile.email;
        final profilePhoto = providerProfile.photoURL;
      }
    }
    return user;
  }

  /// 유저 이름 업데이트
  Future<void> updateProfileName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.updateDisplayName(name);
  }

  /// 유저 url 업데이트
  Future<void> updateProfileUrl(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.updatePhotoURL(url);
  }

  /// 비밀번호 초기화 메일보내기
  Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.setLanguageCode("kr");
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
