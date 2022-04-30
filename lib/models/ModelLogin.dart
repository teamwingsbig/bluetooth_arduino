class ModelLogin {
  ModelLogin({
    required this.result,
  });
  late final List<Result> result;

  ModelLogin.fromJson(Map<String, dynamic> json){
    result = List.from(json['result']).map((e)=>Result.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Result {
  Result({
    required this.id,
    required this.username,
    required this.password,
    required this.type,
    required this.userid,
  });
  late final int id;
  late final String username;
  late final String password;
  late final String type;
  late final int userid;

  Result.fromJson(Map<String, dynamic> json){
    id = json['id'];
    username = json['username'];
    password = json['password'];
    type = json['type'];
    userid = json['userid'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['username'] = username;
    _data['password'] = password;
    _data['type'] = type;
    _data['userid'] = userid;
    return _data;
  }
}