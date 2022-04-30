import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wireless_arduino_project/models/ModelDashboard.dart';
import 'package:wireless_arduino_project/services/master_services.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Row(
          children: [
            Text("Admin Dashboard",
              style: TextStyle(color: Color.fromRGBO(24,49,83, 1)),),
            SizedBox(width: 20,),
            ElevatedButton.icon(onPressed: (){
              Navigator.pushReplacementNamed(context, "Login");
            }, icon: Icon(Icons.logout,size: 15,), label: Text("Logout",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(primary:Color.fromRGBO(24,49,83, 1) ),)

          ],
        ),

        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,

      ),
      body: Column(
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
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder<DashboardModel>(
            future: getDashboardSummary(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return
                  Column(
                    children: [
                      Container(
                          child: Center(
                            child: Text(
                              'Total Registered Doctors: ${snapshot.data!.result[0].DoctorsCount}',
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(color: Colors.white, fontSize: 18),
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
                                  textStyle: TextStyle(color: Colors.white, fontSize: 18),
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
              }
              else{
                return Container();
              }

            }),



          InkWell(
            onTap: (){
              Navigator.pushNamed(context, "doctorRegistration");
            },
            child: Container(
                child: Center(
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/doctor.png'),
                        iconSize: 50,
                        onPressed: () {},
                      ),
                      Text(
                        'Register Doctor',
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
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, "patientRegistration");
            },
            child: Container(
                child: Center(
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/examination.png'),
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
        ],
      ),
    );
  }
}
