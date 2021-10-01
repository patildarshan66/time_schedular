import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:test/login/vm_login.dart';
import 'package:test/time_scheduler.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _pass;
  bool _isLoading = false;

  StreamController<bool> _loginController = StreamController.broadcast();

  @override
  void dispose() {
    _loginController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please login to your account',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 60),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black45, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Email Address",
                        hintStyle: TextStyle(color: Colors.grey[400])),
                    validator: validateEmail,
                    onSaved: (value) {
                      _email = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black45, width: 2),
                            borderRadius: BorderRadius.circular(30)),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey[400])),
                    validator: (value) {
                      if (value == '') {
                        return 'Please Enter password.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _pass = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder(
                    stream: _loginController.stream,
                    builder: (ctx, snapshot) => Column(
                      children: [
                        Visibility(
                          visible: _isLoading,
                          child: CircularProgressIndicator(
                            color: Colors.pink,
                          ),
                        ),
                        Visibility(
                          visible: !_isLoading,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.pink.shade300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: _login,
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    try {
      if (!_formKey.currentState.validate()) {
        return;
      }
      _formKey.currentState.save();
      _isLoading = true;
      _loginController.add(true);
      final res = await VmLogin().login(_email, _pass);
      _isLoading = false;
      _loginController.add(true);
      bool isSuccess = res == 'Login successfully';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res),
          backgroundColor: isSuccess ? Colors.green : Colors.red,
        ),
      );
      if (isSuccess) {
        Navigator.push(
          context,
          PageTransition(
            child: TimeScheduler(),
            type: PageTransitionType.rightToLeft,
          ),
        );
      }
    } catch (e) {
      _isLoading = false;
      _loginController.add(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email Id.';
    else
      return null;
  }
}
