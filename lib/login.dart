import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wireless_arduino_project/services/master_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const redShade = Color.fromRGBO(255, 87, 57, 1);
  static const headerTextStyle = TextStyle(
      color: Colors.lightBlue, fontSize: 28, fontWeight: FontWeight.w700);
  bool _passwordVisible = false;
  bool _isDbKey = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String type = "ADMIN";
  final DBKeyController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _isLoading = false;
  showLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
          body: _isLoading
              ? showLoadingWidget()
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        FadeInUp(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            padding: EdgeInsets.only(top: 100),
                            child: AnimatedOpacity(
                              child: Image.asset(
                                "assets/images/stethoscope128.png",
                                fit: BoxFit.fill,
                              ),
                              duration: Duration(seconds: 1),
                              opacity: 1,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        FadeInUp(
                          child: Text(
                            "Login",
                            style: headerTextStyle,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        FadeInUp(
                          delay: Duration(microseconds: 800),
                          duration: Duration(microseconds: 1500),
                          child: InputeField(
                              labelText: "Username",
                              prefixIcon: Icons.supervised_user_circle_sharp,
                              hintText: "Enter userame",
                              controller: usernameController),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        FadeInUp(
                          delay: Duration(microseconds: 800),
                          duration: Duration(microseconds: 1500),
                          child: InputeField(
                              labelText: "Password",
                              prefixIcon: Icons.vpn_key,
                              hintText: "Enter Password",
                              suffixIcon: IconButton(
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              obscureText: _passwordVisible,
                              controller: passwordController),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField<String>(
                          value: type,
                            decoration: InputDecoration(
                                labelText: "Select User Type",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                hintText: "Usertype",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                                    borderRadius: BorderRadius.circular(10)),

                                floatingLabelStyle: TextStyle(color: Colors.black, fontSize: 18),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                                    borderRadius: BorderRadius.circular(10)),
                                prefixIcon: Icon(
                                  Icons.supervised_user_circle_sharp,
                                  color: Colors.black,
                                  size: 18,
                                )),
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,

                          onChanged: (String? newValue) {
                            setState(() {
                              type = newValue!;
                            });
                          },
                          items: <String>['ADMIN', 'DOCTOR',  'PATIENT']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FadeInUp(
                            delay: Duration(microseconds: 800),
                            duration: Duration(microseconds: 1500),
                            child: LoginButton(
                              callback: () => {
                                _doLogin(usernameController.text,
                                    passwordController.text, type)
                              },
                            )),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }

  _doLogin(String username, String password, String type) async {
    // Navigator.pushReplacementNamed(context, "adminDashboard");
    showLoading(true);
    if (username.toString().isNotEmpty &&
        password.toString().isNotEmpty &&
        type.toString().isNotEmpty) {
      var result = await login_service().doLogin(username, password, type);
      print(result);
      if (result["status"] == 1) {
        if (result["type"] == "ADMIN") {
          Navigator.pushReplacementNamed(context, "adminDashboard");
        }
        else if (result["type"] == "DOCTOR") {
          Navigator.pushReplacementNamed(context, "doctorDashboard");
        }
        else if (result["type"] == "PATIENT") {
          Navigator.pushReplacementNamed(context, "adminDashboard");
        }


      } else {
        showLoading(false);
        String val = result["message"].toString();
        _scaffoldMessengerKey.currentState!
            .showSnackBar(new SnackBar(content: new Text(val)));
      }
    } else {
      showLoading(false);
      String val = "Invalid user credentials";
      _scaffoldMessengerKey.currentState!
          .showSnackBar(new SnackBar(content: new Text(val)));
    }
  }

  Widget InputeField(
      {String labelText = "",
      IconData? prefixIcon,
      String hintText = "",
      IconButton? suffixIcon,
      bool obscureText = false,
      required TextEditingController controller}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      obscureText: obscureText,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
              borderRadius: BorderRadius.circular(10)),
          suffixIcon: suffixIcon,
          floatingLabelStyle: TextStyle(color: Colors.black, fontSize: 18),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.5),
              borderRadius: BorderRadius.circular(10)),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.black,
            size: 18,
          )),
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

class LoginButton extends StatelessWidget {
  final VoidCallback callback;
  const LoginButton({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: callback,
      height: 45,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Text(
        "Login",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
