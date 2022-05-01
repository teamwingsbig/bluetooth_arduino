import 'package:flutter/material.dart';
import 'package:wireless_arduino_project/models/ModelPatientList.dart';
import 'package:wireless_arduino_project/services/master_services.dart';

class PatientListPopup extends StatefulWidget {
  const PatientListPopup({Key? key,required this.onSelectLedger}) : super(key: key);
  final ValueChanged<Map> onSelectLedger;


  @override
  _PatientListPopupState createState() => _PatientListPopupState();
}

class _PatientListPopupState extends State<PatientListPopup> {
  TextEditingController _TxtLedger=new TextEditingController();
  List<PatientListModel>LedgerList=[];
  List<PatientListModel>searchList=[];
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    isLoading=true;
    fetchPatientList();
  }
  void fetchPatientList()async{

    LedgerList=await master_service().getPatientList();
    searchList=LedgerList;
    print(LedgerList[0].id);
  }
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, setState) => Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Heading(showAll: false, text: "Select Patient"),
                  Divider(
                    color:  Color.fromRGBO(24,49,83, 1),
                    endIndent: MediaQuery.of(context).size.width*0.07,
                    indent: 22,
                    thickness: 0.6,
                  ),
                  Padding(padding: const EdgeInsets.only(top: 8,left: 20,right: 20,bottom: 8),
                    child:  TextField(
                      controller: _TxtLedger,
                      onChanged: (query) {
                        setState(() {

                          searchFromList(query);
                        });

                      },
                      decoration: InputDecoration(

                        hintText: "Search Patient (Mobile / Name / Email)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search,size: 30,),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(

                        itemCount: LedgerList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),

                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.all(0.0),
                          child: ListTile(

                            onTap: (){
                              print(LedgerList[index]);

                              print("ontap");
                              // print(customerList[index].ledgerName);
                              //  _TxtCustomerControlelr.text=customerList[index].ledgerName;
                              // customerLedgerId=customerList[index].id;
                              var ledgerDetails={
                                'PatientId':LedgerList[index].id,
                                'PatientName':LedgerList[index].PatientName,
                                'age':LedgerList[index].age
                              };
                              widget.onSelectLedger(ledgerDetails);
                              Navigator.of(context).pop();
                            },
                            title: Text(LedgerList[index].PatientName.toString()),

                          ),
                        ),
                      ),
                    ),
                  ),


                ],
              ),

            )
        )
    );
  }

  Widget Heading({required bool showAll,required String text}){
    return  Container(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,

          ),


        ],
      ),
    );
  }
  static const TextStyle headline = TextStyle(
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: Color.fromRGBO(24,49,83, 1),
  );
  void searchFromList(String query){

    LedgerList=searchList;
    query=query.toLowerCase();

    List<PatientListModel>searchListResult=[];
    LedgerList.forEach((element) {
      var ledgerName=element.PatientName
      !.toLowerCase();
      var mobile=element.Mobile
      !.toLowerCase();
      var email=element.Email
      !.toLowerCase();

      if(ledgerName.contains(query) || mobile.contains(query) ||email.contains(query)){
        searchListResult.add(element);
      }
    });
    LedgerList=searchListResult;
  }
}
