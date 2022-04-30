class DoctorProfileModel {
  DoctorProfileModel({
    required this.result,
  });
  late final List<Result> result;

  DoctorProfileModel.fromJson(Map<String, dynamic> json){
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
    required this.DoctorName,
    required this.Address,
    required this.Mobile,
    required this.Department,
    required this.Email,
  });
  late final String DoctorName;
  late final String Address;
  late final String Mobile;
  late final String Department;
  late final String Email;

  Result.fromJson(Map<String, dynamic> json){
    DoctorName = json['DoctorName'];
    Address = json['Address'];
    Mobile = json['Mobile'];
    Department = json['Department'];
    Email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['DoctorName'] = DoctorName;
    _data['Address'] = Address;
    _data['Mobile'] = Mobile;
    _data['Department'] = Department;
    _data['Email'] = Email;
    return _data;
  }
}