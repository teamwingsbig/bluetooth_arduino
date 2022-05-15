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
        foregroundColor: Colors.green,
        primary: true,
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Dashboard",
              style: TextStyle(color:Colors.white),),

            InkWell(child: Text("Logout",style: TextStyle(color: Colors.white),),onTap: (){
              Navigator.pushReplacementNamed(context, "Login");
            },),

          ],
        ),



      ),
      body: Column(
        children: [SizedBox(
          height: 20,
        ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/stethoscope256.png",
              fit: BoxFit.fill,
            )
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: FutureBuilder<DashboardModel>(
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
                                    textStyle: TextStyle(color: Colors.blueGrey, fontSize: 18),
                                    letterSpacing: 0.3),
                              ),
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                              ),
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
                                    textStyle: TextStyle(color: Colors.blueGrey, fontSize: 18),
                                    letterSpacing: 0.3),
                              ),
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                              ),
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
          ),



          InkWell(
            onTap: (){
              Navigator.pushNamed(context, "doctorRegistration");
            },
            child: Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                TextStyle(color: Colors.blueGrey, fontSize: 22),
                            letterSpacing: 0.3,fontWeight: FontWeight.bold ),
                      )
                    ],
                  ),
                ),
                height: 50,
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                TextStyle(color: Colors.blueGrey, fontSize: 22),
                            letterSpacing: 0.3,fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                height: 50,
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
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
