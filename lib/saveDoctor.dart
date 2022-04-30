
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:wireless_arduino_project/services/master_services.dart';

class SaveDoctor_Screen extends StatefulWidget {
  const SaveDoctor_Screen({Key? key}) : super(key: key);

  @override
  _SaveDoctor_ScreenState createState() => _SaveDoctor_ScreenState();
}

class _SaveDoctor_ScreenState extends State<SaveDoctor_Screen> {
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
        title: Text("Doctor Registration",
         ),
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowAltCircleLeft,

          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.lightBlue,
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
              boxShadow: [
                BoxShadow(
                  color:Colors.lightBlue,
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),

            child: Padding(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FormBuilderTextField(name: "doctorname",
                      validator: FormBuilderValidators.required(context,errorText: "Invalid Doctor Name"),
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: 'Doctor Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                            Icons.text_fields
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    FormBuilderDropdown(
                      name: 'department',

                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Department ',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                            Icons.document_scanner_sharp
                        ),
                      ),
                      items: [
                        "Allergists/Immunologists",
                        "Anesthesiologists",
                        "Cardiologists",
                        "Dermatologists",
                        "Gastroenterologists",
                        "Geriatric Medicine Specialists",
                        "Hematologists",
                        "Infectious Disease Specialists",
                        "Nephrologists",
                        "Neurologists","Obstetricians and Gynecologists","Oncologists","Ophthalmologists","Pediatricians","Radiologists"
                      ].map((option) {
                        return DropdownMenuItem(
                          child: Text("$option"),
                          value: option,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 8,),
                    FormBuilderTextField(name: "mobile",

                      autofocus: false,
                      maxLines: 2,
                      decoration: InputDecoration(
                          labelText: 'Mobile',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.text_snippet_sharp)
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
                    FormBuilderTextField(name: "email",

                      autofocus: false,
                      maxLines: 2,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.text_snippet_sharp)
                      ),
                    ),
                    SizedBox(height: 8,),

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
                    FormBuilderTextField(name: "remark",

                      autofocus: false,
                      maxLines: 2,
                      decoration: InputDecoration(
                          labelText: 'Remark',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.text_snippet_sharp)
                      ),
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

                            await saveDoctorRegistration(_formKey.currentState!.fields['doctorname']!.value.toString(),_formKey.currentState!.fields['address']!.value.toString(),_formKey.currentState!.fields['department']!.value.toString(),_formKey.currentState!.fields['gender']!.value.toString(),_formKey.currentState!.fields['email']!.value.toString(),_formKey.currentState!.fields['remark']!.value.toString(),_formKey.currentState!.fields['mobile']!.value.toString());
                            //  _formKey.currentState!.reset();
                          }
                        }, icon: Icon(Icons.check_circle), label: Text("Submit"),style: ElevatedButton.
                        styleFrom(primary: Color.fromRGBO(24,49,83, 1)),),
                        SizedBox(width: 10,),
                        ElevatedButton.icon(onPressed: (){
                          resetForm();
                        }, icon: Icon(Icons.refresh_sharp), label: Text("Reset"),style: ElevatedButton.
                        styleFrom(primary: Color.fromRGBO(24,49,83, 1)),)

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
  saveDoctorRegistration(String doctorName,String address,String department,String gender,String email,String remark,String mobile)async{


    var data={"doctorname":doctorName, "address":address,
      "department":department,"gender":gender,"email":email,"remark": remark,"mobile": mobile};
    print(data);
    var result=await master_service().saveDoctors(data);
  print(result);
    if(result["status"]==1){
      Get.snackbar(

        "Doctor Registration",
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

        "Doctor Registration",
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
