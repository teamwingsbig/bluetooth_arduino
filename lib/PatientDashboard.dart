import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wireless_arduino_project/models/ModelPatientProfile.dart';
import 'package:wireless_arduino_project/services/master_services.dart';

import 'models/ModelDashboard.dart';
import 'models/ModelDoctorProfile.dart';
import 'package:wireless_arduino_project/constants/string.dart' as appSettings;

import 'models/ModelPatientCheckup.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({Key? key}) : super(key: key);

  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  List<PatientCheckupModel>lstCheckupList=[];
  fetchPatientCheckupList(int patientId)async{

    lstCheckupList=await master_service().getPatientCheckupList(patientId);
    setState(() {

    });
  print(lstCheckupList.length);
  }
  @override
  void initState() {
    // TODO: implement initState
    print(appSettings.userId);
    fetchPatientCheckupList(appSettings.userId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Patient Dashboard",
              style: TextStyle(color: Color.fromRGBO(24, 49, 83, 1)),
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "Login");
              },
              icon: Icon(
                Icons.logout,
                size: 15,
              ),
              label: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(24, 49, 83, 1)),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: Center(
                    child: ListTile(
                      title: Text(
                        "Welcome to Blue Scope ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700),
                      ),
                      leading: Image.asset(
                        "assets/images/stethoscope128.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder<PatientProfileModel>(
                future:  master_service().getPatientProfile(appSettings.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data!.result);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  "Profile",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: snapshot.data!.result.length>0?Text(
                                  "Name: ${snapshot.data!.result[0].PatientName}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ):Text(''),
                              ),
                              Center(
                                child: snapshot.data!.result.length>0?Text(
                                  "Mobile: ${snapshot.data!.result[0].Mobile}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ):Text(''),
                              ),
                              Center(
                                child: snapshot.data!.result.length>0?Text(
                                  "Address: ${snapshot.data!.result[0].Address}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ):Text(''),
                              ),
                            ],
                          ),
                          height: 130,
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          )),
                    );
                  } else {
                    return Container();
                  }
                }),


            Text(
              "Previous History",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(
              height: 10,
            ),
            ListView.separated(itemBuilder: (contex, index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 1), borderRadius: BorderRadius.circular(5)),

                  title: Center(child: Text("Checkup Date: ${lstCheckupList[index].CheckupDate.toString()}")),
                  isThreeLine: true,
                  subtitle: Column(children: [
                    SizedBox(height: 10,),
                    Text("BPM: ${lstCheckupList[index].BPM.toString()}"),
                    SizedBox(height: 10,),
                    Text("BPM Status: ${lstCheckupList[index].BPMStatus.toString()}"),
                    SizedBox(height: 10,),
                    Text("Remark: ${lstCheckupList[index].Remark.toString()}"),
                  ],),
                ),
              );
            }, separatorBuilder: (context, index){
              return Divider();
            }, itemCount: lstCheckupList.length,
              shrinkWrap: true,
            )


          ],
        ),
      ),
    );
  }
}
