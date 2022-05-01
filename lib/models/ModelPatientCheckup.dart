
import 'dart:convert';

List<PatientCheckupModel> PatientCheckupListModelFromJson(String str) => List<PatientCheckupModel>.from(json.decode(str).map((x) => PatientCheckupModel.fromJson(x)));

String PatientCheckupListModelToJson(List<PatientCheckupModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PatientCheckupModel {
  PatientCheckupModel({
   this.CheckupDate,
    this.Remark,
    this.BPM,
    this.BPMStatus

  });


  String? CheckupDate;
  String? Remark;
  String? BPM;
  String? BPMStatus;


  factory PatientCheckupModel.fromJson(Map<String, dynamic> json) => PatientCheckupModel(
    CheckupDate: json["CheckupDate"],
    Remark: json["Remark"],
    BPM: json["BPM"],
    BPMStatus: json["BPMStatus"],

  );

  Map<String, dynamic> toJson() => {
    "CheckupDate": CheckupDate,
    "Remark": Remark,
    "BPM": BPM,
    "BPMStatus": BPMStatus

  };
}
