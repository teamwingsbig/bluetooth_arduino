
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:wireless_arduino_project/services/master_services.dart';

class SavePatients extends StatefulWidget {
  const SavePatients({Key? key}) : super(key: key);

  @override
  _SavePatientsState createState() => _SavePatientsState();
}

class _SavePatientsState extends State<SavePatients> {
  bool _isLoading=false;
  final _formKey = GlobalKey<FormBuilderState>();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Patient Registration",
        ),
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowAltCircleLeft,

          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.lightGreen,
        bottomOpacity: 0.0,
        elevation: 0.0,

      ),
      body: _isLoading?showLoadingWidget(): FormBuilder(
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

            ),

            child: Padding(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/patient.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: 10,),
                    FormBuilderTextField(name: "PatientName",
                      validator: FormBuilderValidators.required(context,errorText: "Invalid Doctor Name"),
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: 'Patient Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                            Icons.text_fields
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    FormBuilderTextField(name: "email",

                      autofocus: false,
                      maxLines: 2,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email)
                      ),
                    ),
                    SizedBox(height: 8,),
                    FormBuilderTextField(name: "mobile",

                      autofocus: false,
                      keyboardType: TextInputType.number,
                      maxLines: 2,
                      decoration: InputDecoration(
                          labelText: 'Mobile',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.text_snippet_sharp)
                      ),
                    ),
                    SizedBox(height: 8,),
                    FormBuilderTextField(name: "age",

                      autofocus: false,      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.numbers)
                      ),
                    ),
                    SizedBox(height: 8,),
                    FormBuilderTextField(name: "address",

                      autofocus: false,
                      maxLines: 2,
                      decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.text_snippet_sharp)
                      ),
                    ),
                    SizedBox(height: 8,),

                    FormBuilderRadioGroup(
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                            Icons.compare_arrows_outlined
                        ),
                      ),
                      name: 'gender',
                      initialValue: "Male",
                      validator: FormBuilderValidators.required(context),
                      options: [
                        'Male','Female'
                      ]
                          .map((lang) => FormBuilderFieldOption(value: lang))
                          .toList(growable: false),
                    ),




                    SizedBox(height: 8,),



                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(onPressed: ()async{
                          _formKey.currentState!.save();
                          final validation=_formKey.currentState!.validate();
                          // print(validation);
                          if(validation){
                            //await saveAdvance();
                            print("DOcument Valid");

                            await savePatientRegistration(_formKey.currentState!.fields['patientName']!.value.toString(),_formKey.currentState!.fields['address']!.value.toString(),_formKey.currentState!.fields['age']!.value.toString(),_formKey.currentState!.fields['gender']!.value.toString(),_formKey.currentState!.fields['email']!.value.toString(),_formKey.currentState!.fields['mobile']!.value.toString());
                            //  _formKey.currentState!.reset();
                          }
                        }, icon: Icon(Icons.check_circle), label: Text("Submit"),style: ElevatedButton.
                        styleFrom(primary: Colors.green),),
                        SizedBox(width: 10,),
                        ElevatedButton.icon(onPressed: (){
                          resetForm();
                        }, icon: Icon(Icons.refresh_sharp), label: Text("Reset"),style: ElevatedButton.
                        styleFrom(primary: Colors.green),)

                      ],
                    )


                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
  savePatientRegistration(String patientName,String address,String age,String gender,String email,String mobile)async{


    var data={"patientName":patientName, "address":address,
      "age":age,"gender":gender,"email":email,"mobile": mobile};
    print(data);
    var result=await master_service().savePatient(data);
    print(result);
    if(result["status"]==1){
      Get.snackbar(

        "Patient Registration",
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
      resetForm();
      showLoading(false);

    }else{
      Get.snackbar(

        "Patient Registration",
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
      showLoading(false);

    }

  }
  showLoading(bool loading){
    setState(() {
      _isLoading=loading;
    });
  }
  void resetForm(){
    if(_formKey!=null)
      if(_formKey.currentState!=null)
        _formKey.currentState!.reset();
  }
}

