class DashboardModel {
  DashboardModel({
    required this.result,
  });
  late final List<Result> result;

  DashboardModel.fromJson(Map<String, dynamic> json){
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
    required this.DoctorsCount,
    required this.PatientsCount,
  });
  late final int DoctorsCount;
  late final int PatientsCount;

  Result.fromJson(Map<String, dynamic> json){
    DoctorsCount = json['DoctorsCount'];
    PatientsCount = json['PatientsCount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['DoctorsCount'] = DoctorsCount;
    _data['PatientsCount'] = PatientsCount;
    return _data;
  }
}