import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wireless_arduino_project/constants/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:wireless_arduino_project/models/ModelDashboard.dart';
import 'package:wireless_arduino_project/models/ModelLogin.dart' as modelLogin;
import 'package:wireless_arduino_project/constants/string.dart' as appSettings;
import 'package:wireless_arduino_project/models/ModelPatientCheckup.dart';
import 'package:wireless_arduino_project/models/ModelPatientProfile.dart';

import '../models/ModelDoctorProfile.dart';
import '../models/ModelLogin.dart';
import '../models/ModelPatientList.dart';
class login_service{
  Future<Map<String, dynamic>> doLogin(String username,String password,String type)async{

    var url = Uri.parse(api_url.loginURL+'?username=${username}&password=$password&type=${type}');
    print(url);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonMap = json.decode(response.body);

        List<dynamic>result=jsonMap['result'];
        print(result);


        if(result.length>0){
          var result=ModelLogin.fromJson(jsonMap);
          print(result);
          if(result.result!=null){

            setUserDetails(result.result[0]);

            return {"status":1,
              "message":"Login Succesfull","type":type
            };
          }
          else{
            return {"status":0,
              "message":"Incorect Login Credentials"
            };
          }
        }
        else{
          return {"status":0,
            "message":"Incorect Login Credentials"
          };
        }



      }
    } catch (Exception) {
      print(Exception);
      return {"status":0,
        "message":Exception
      };
    }
    return {"status":0,
      "message":"Something went Wrong.. Try Again"
    };

  }
  setUserDetails(modelLogin.Result model)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userDetails", json.encode(model));
    setappSettingsUser(model);

  }
  void setappSettingsUser(modelLogin.Result model){

    appSettings.type=model.type;
    appSettings.userId=model.userid;


  }



}

Future<DashboardModel> getDashboardSummary() async {

  var url = Uri.parse(api_url.dashboardURL);
  var summaryModel = null;
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonMap = json.decode(response.body);

      summaryModel = DashboardModel.fromJson(jsonMap);

    }
  } catch (Exception) {
    print(Exception);
    return summaryModel;
  }
  return summaryModel;
}
Future<DoctorProfileModel> getDoctorProfile(int userId) async {

  var url = Uri.parse(api_url.getDoctorProfile_URL+userId.toString());
  var summaryModel = null;
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonMap = json.decode(response.body);
      summaryModel = DoctorProfileModel.fromJson(jsonMap);
    }
  } catch (Exception) {
    print(Exception);
    return summaryModel;
  }
  return summaryModel;
}

class master_service{
  Future<PatientProfileModel> getPatientProfile(int userId) async {

    var url = Uri.parse(api_url.getPatientProfile_URL+userId.toString());
    var summaryModel = null;
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonMap = json.decode(response.body);
        summaryModel = PatientProfileModel.fromJson(jsonMap);
      }
    } catch (Exception) {
      print(Exception);
      return summaryModel;
    }
    return summaryModel;
  }
  getPatientList() async {
    var url = Uri.parse(api_url.getPatientList_URL);
    print(url);
    var patientList = null;
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonMap = json.decode(response.body);
        // print(response.body);
        print(jsonMap);
        patientList = ledgerModelFromJson(jsonEncode(jsonMap['result']));
      }
    } catch (Exception) {
      print(Exception);
      return patientList;
    }
    return patientList;
  }
  getPatientCheckupList(int patientId) async {
    var url = Uri.parse(api_url.getPatientCheckupList_URL+patientId.toString());
    print(url);
    var patientList = null;
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonMap = json.decode(response.body);
        // print(response.body);
        print(jsonMap);
        patientList = PatientCheckupListModelFromJson(jsonEncode(jsonMap['result']));
      }
    } catch (Exception) {
      print(Exception);
      return patientList;
    }
    return patientList;
  }
  getPatienCheckupList() async {
    var url = Uri.parse(api_url.getPatientList_URL);
    print(url);
    var patientList = null;
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonMap = json.decode(response.body);
        // print(response.body);
        print(jsonMap);
        patientList = ledgerModelFromJson(jsonEncode(jsonMap['result']));
      }
    } catch (Exception) {
      print(Exception);
      return patientList;
    }
    return patientList;
  }

  Future<Map<String, dynamic>>saveDoctors(Map<String, dynamic> data)async{
    try{
      print(data);
      var url = Uri.parse(api_url.saveDoctor_URL);
      final headers = {"Content-type": "application/json"};

      final response = await http.post(url, headers: headers, body: jsonEncode(data));
      var result=json.decode(response.body);
       print(result);

      return {"status":1,"message":"Doctor Registered Succesfully"};
    }
    catch(Exception){
      return {"status":0,"message":Exception};
    }

  }
  Future<Map<String, dynamic>>saveCheckup(Map<String, dynamic> data)async{
    try{
      print(data);
      var url = Uri.parse(api_url.saveCheckup_URL);
      final headers = {"Content-type": "application/json"};

      final response = await http.post(url, headers: headers, body: jsonEncode(data));
      var result=json.decode(response.body);
      print(result);

      return {"status":1,"message":"Checkup Added Succesfully"};
    }
    catch(Exception){
      return {"status":0,"message":Exception};
    }

  }
  Future<Map<String, dynamic>>savePatient(Map<String, dynamic> data)async{
    try{
      print(data);
      var url = Uri.parse(api_url.savePatient_URL);
      final headers = {"Content-type": "application/json"};

      final response = await http.post(url, headers: headers, body: jsonEncode(data));
      var result=json.decode(response.body);
      print(result);

      return {"status":1,"message":"Patient Registered Succesfully"};
    }
    catch(Exception){
      return {"status":0,"message":Exception};
    }

  }
}

