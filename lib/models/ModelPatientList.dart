// To parse this JSON data, do
//
//     final ledgerModel = ledgerModelFromJson(jsonString);
//app.quicktype.com
import 'dart:convert';

List<PatientListModel> ledgerModelFromJson(String str) => List<PatientListModel>.from(json.decode(str).map((x) => PatientListModel.fromJson(x)));

String ledgerModelToJson(List<PatientListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PatientListModel {
  PatientListModel({
    this.id,
    this.PatientName,
    this.Address,
    this.Mobile,
    this.Email,
    this.Gender,
    this.age

  });

  int? id;
  String? PatientName;
  String? Address;
  String? Mobile;
  String? Email;
  String? Gender;
  int? age;

  factory PatientListModel.fromJson(Map<String, dynamic> json) => PatientListModel(
    id: json["id"],
    PatientName: json["PatientName"],
    Address: json["Address"],
    Mobile: json["Mobile"],
    Email: json["Email"],
    Gender: json["Gender"],
    age: json["age"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "PatientName": PatientName,
    "Address": Address,
    "Mobile": Mobile,
    "Email": Email,
    "Gender": Gender,
    "age": age,
  };
}
