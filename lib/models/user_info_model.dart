

class UserInfoModel{
  final String email;
  final String password;
  final String nickname;
  final String number;

  UserInfoModel({
    this.email = '',
    this.password = '',
    this.nickname = '',
    this.number = '',
  });

  factory UserInfoModel.fromMap({required Map<String, dynamic> map}){
    return UserInfoModel(
      email: map['email']??'',
      password: map['password']??'',
      nickname: map['nickname']??'',
      number: map['number']??''

    );
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> data = {};
    data['email']=email;
    data['password']=password;
    data['nickname']=nickname;
    data['number']=number;
    return data;
  }

}