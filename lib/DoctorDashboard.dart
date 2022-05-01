import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wireless_arduino_project/services/master_services.dart';

import 'models/ModelDashboard.dart';
import 'models/ModelDoctorProfile.dart';
import 'package:wireless_arduino_project/constants/string.dart' as appSettings;

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);

  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {

  @override
  void initState() {
    // TODO: implement initState
    print(appSettings.userId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Doctor Dashboard",
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
                        "Welcome to My Blue Steth App",
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
            FutureBuilder<DoctorProfileModel>(
                future:  getDoctorProfile(appSettings.userId),
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
                                  "Name: ${snapshot.data!.result[0].DoctorName}",
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
                                  "Department: ${snapshot.data!.result[0].Department}",
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

            SizedBox(
              height: 10,
            ),
            FutureBuilder<DashboardModel>(
                future: getDashboardSummary(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Container(
                            child: Center(
                              child: Text(
                                'Total Registered Doctors: ${snapshot.data!.result[0].DoctorsCount}',
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                    letterSpacing: 0.3),
                              ),
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              color: Colors.green.shade500,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: Center(
                              child: Text(
                                'Total Registered Patient:  ${snapshot.data!.result[0].PatientsCount}',
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                    letterSpacing: 0.3),
                              ),
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade500,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "patientRegistration");
              },
              child: Container(
                  child: Center(
                    child: Row(
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/registration.png'),
                          iconSize: 50,
                          onPressed: () {},
                        ),
                        Text(
                          'Register Patient',
                          style: GoogleFonts.lato(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              letterSpacing: 0.3),
                        )
                      ],
                    ),
                  ),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen.shade400,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  )),
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "beginCheckup");
              },
              child: Container(
                  child: Center(
                    child: Row(
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/examination.png'),
                          iconSize: 50,
                          onPressed: () {

                          },
                        ),
                        Text(
                          'Begin Checkup',
                          style: GoogleFonts.lato(
                              textStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                              letterSpacing: 0.3),
                        )
                      ],
                    ),
                  ),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen.shade400,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  )),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
