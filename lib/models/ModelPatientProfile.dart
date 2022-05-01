class PatientProfileModel {
  PatientProfileModel({
    required this.result,
  });
  late final List<Result> result;

  PatientProfileModel.fromJson(Map<String, dynamic> json){
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
    required this.PatientName,
    required this.Address,
    required this.Mobile,
    required this.Email,
  });
  late final String PatientName;
  late final String Address;
  late final String Mobile;
  late final String Email;

  Result.fromJson(Map<String, dynamic> json){
    PatientName = json['PatientName'];
    Address = json['Address'];
    Mobile = json['Mobile'];
    Email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['PatientName'] = PatientName;
    _data['Address'] = Address;
    _data['Mobile'] = Mobile;
    _data['Email'] = Email;
    return _data;
  }
}