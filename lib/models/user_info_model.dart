class UserInfoModel {
  final String id;
  final String nickname;
  final String number;

  UserInfoModel({
    this.id = '',
    this.nickname = '',
    this.number = '',
  });

  factory UserInfoModel.fromMap(
      {required String id, required Map<dynamic, dynamic> map}) {
    return UserInfoModel(
        id: id, nickname: map['nickname'] ?? '', number: map['number'] ?? '');
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['nickname'] = nickname;
    data['number'] = number;
    return data;
  }
}
