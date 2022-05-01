import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wireless_arduino_project/services/master_services.dart';
import 'package:wireless_arduino_project/services/patientListPopup.dart';
import 'package:wireless_arduino_project/constants/string.dart' as appSettings;
import 'package:intl/intl.dart';

import 'HomePage.dart';

import 'models/ModelPatientCheckup.dart';
class BeginCheckup extends StatefulWidget {
  const BeginCheckup({Key? key}) : super(key: key);

  @override
  _BeginCheckupState createState() => _BeginCheckupState();
}

class _BeginCheckupState extends State<BeginCheckup> {
  int patientId=0;
  int age=0;
  bool _isLoading=false;
  List<PatientCheckupModel>lstCheckupList=[];
  final DateFormat _dateFormatter = DateFormat('dd-MMM-yyyy');
  final _formKey = GlobalKey<FormBuilderState>();
   fetchPatientCheckupList(int patientId)async{

    lstCheckupList=await master_service().getPatientCheckupList(patientId);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowAltCircleLeft,
            color: Color.fromRGBO(24, 49, 83, 1),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Text(
              "Begin Checkup",
              style: TextStyle(color: Color.fromRGBO(24, 49, 83, 1)),
            ),

          ],
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:_isLoading?showLoadingWidget(): FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15),
            height: MediaQuery
                .of(context)
                .size
                .height -110,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),

            child: Padding(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    SizedBox(height: 10,),
                    _formFieldLedger(builderName: "patientBuilder", fieldName: "patient", validationMessage: "Select a Patient", labelText: "Select a Patient"),
                    SizedBox(height: 10,),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: SizedBox(width: 140,height: 30, child: ElevatedButton.icon(onPressed: ()async{
                        await fetchPatientCheckupList(patientId);
                        showBarModalBottomSheet(
                            expand: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context){
                              return   Container(
                                height: MediaQuery.of(context).size.height*0.7,
                                child: SingleChildScrollView(

                                  child: ListView.separated(itemBuilder: (contex, index){
                                    return ListTile(

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
                                    );
                                  }, separatorBuilder: (context, index){
                                    return Divider();
                                  }, itemCount: lstCheckupList.length,
                                    shrinkWrap: true,
                                  ),
                                ),
                              );
                            });

                      },style: ElevatedButton.styleFrom(primary:Color.fromRGBO(24, 49, 83, 1) ), icon: Icon(Icons.history,size: 15,), label: Text("Show History"))),
                    ),
                    SizedBox(height: 10,),


                    FormBuilderDateTimePicker(

                      autofocus: false,
                      name: "invoiceDate",
                      initialDate: DateTime.now(),
                      initialValue: DateTime.now(),
                      inputType: InputType.date,
                      format: DateFormat("dd-MMM-yyyy"),
                      decoration: InputDecoration(
                        labelText: 'Invoice Date',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                            Icons.calendar_today
                        ),
                      ),
                      initialEntryMode: DatePickerEntryMode.calendar,
                    ),
                    SizedBox(height: 10,),
                    FormBuilderTextField(name: "remark",
                      autofocus: false,
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Remark',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                            Icons.speaker_notes
                        ),
                      ),

                    ),
                    SizedBox(height: 20,),
                    Center(child: ElevatedButton.icon(onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) {
                                return ConnectBluetoothDevice(age: age,onSelectPatient: (value){

                                  _formKey.currentState!.fields["bpm"]!.didChange(value["bpm"].toString());
                                  _formKey.currentState!.fields["bpmStatus"]!.didChange(value["bpmStatus"].toString());
                                },);
                              }));
                    },style: ElevatedButton.styleFrom(primary:Color.fromRGBO(24, 49, 83, 1) ), icon: Icon(Icons.stacked_line_chart), label: Text("Check BPM")),),
                    SizedBox(height: 20,),
                    FormBuilderTextField(name: "bpm",
                      autofocus: false,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'BPM',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                            Icons.speaker_notes
                        ),
                      ),

                    ),
                    SizedBox(height: 20,),
                    FormBuilderTextField(name: "bpmStatus",
                      autofocus: false,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'BPM Status',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                            Icons.speaker_notes
                        ),
                      ),

                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(onPressed: ()async{
                          _formKey.currentState!.save();
                          final validation=_formKey.currentState!.validate();
                          print(validation);
                          if(validation){
                            await saveCheckup();
                            //  _formKey.currentState!.reset();
                          }
                        }, icon: Icon(Icons.check_circle), label: Text("Submit"),style: ElevatedButton.
                        styleFrom(primary: Color.fromRGBO(24, 49, 83, 1)),),
                        SizedBox(width: 10,),
                        ElevatedButton.icon(onPressed: (){
                          resetForm();
                        }, icon: Icon(Icons.refresh_sharp), label: Text("Reset"),style: ElevatedButton.
                        styleFrom(primary: Color.fromRGBO(24, 49, 83, 1)),)

                      ],
                    )


                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  showLoading(bool loading){
    setState(() {
      _isLoading=loading;
    });
  }
  saveCheckup()async{
    showLoading(true);
    var data={"DoctorId":appSettings.userId.toString(), "PatientId":patientId.toString(),
      "CheckupDate":_dateFormatter.format(DateTime.parse(_formKey.currentState!.fields['invoiceDate']!.value.toString())),"remark":_formKey.currentState!.fields['remark']!.value.toString(),"BPM":_formKey.currentState!.fields['bpm']!.value.toString(),"BPMStatus":_formKey.currentState!.fields['bpmStatus']!.value.toString()};

    var result=await master_service().saveCheckup(data);
    if(result["status"]==1){
      resetForm();
      showLoading(false);
      Get.snackbar(

        "Patient Checkup",
        result["message"],
        icon: Icon(Icons.check_circle, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        borderRadius: 10,
        margin: EdgeInsets.all(15),
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,

      );
    }else{
      showLoading(false);
      Get.snackbar(

        "Patient Checkup",
        result["message"],
        icon: Icon(Icons.error, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.deepOrangeAccent,
        borderRadius: 10,
        margin: EdgeInsets.all(15),
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,

      );
    }
  }
  void resetForm(){
    if(_formKey!=null)
      if(_formKey.currentState!=null)
        _formKey.currentState!.reset();
    patientId=0;

  }
  Widget _formFieldLedger({required String builderName,required String fieldName,required String validationMessage,required String labelText}){
    return FormBuilderField(
        name: builderName,
        builder: (FormFieldState<dynamic> field){
          return FormBuilderTextField(
            autofocus: false,
            validator: (val){
              if(patientId==0 || patientId==null){
                return validationMessage;
              }


              return null;
            },
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                  Icons.import_export_sharp
              ),
            ),
            name: fieldName,
            onTap: (){
              showBarModalBottomSheet(



                  expand: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context){
                    return   PatientListPopup(onSelectLedger:(value){
                      print(value);
                      patientId=int.parse(value["PatientId"].toString()) ;
                      age=int.parse(value["age"].toString()) ;
                      _formKey.currentState!.fields[fieldName]!.didChange(value["PatientName"]);


                    });
                  });
            },

          );
        }
    );
  }
  Widget showLoadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoActivityIndicator(),
          ],
        )
      ],
    );
  }
}
