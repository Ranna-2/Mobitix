import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'LoginPage.dart'; // Import the LoginPage or relevant page

class SignupPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Sign Up",
                          style: TextStyle(
                              color: CupertinoColors.systemGreen,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Create a new account for Mobitix",
                          style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: <Widget>[
                          inputFile(label: "Email", controller: emailController),
                          inputFile(
                              label: "Password",
                              obscureText: true,
                              controller: passwordController),
                          inputFile(
                              label: "Confirm Password",
                              obscureText: true,
                              controller: confirmPasswordController),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black),
                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();
                            String confirmPassword = confirmPasswordController.text.trim();

                            if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Email and Password fields cannot be empty.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return;
                            }
                            if (password != confirmPassword) { // Check if passwords match
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Passwords do not match")),
                              );
                              return;
                            }

                            // Navigate to LoginPage directly for now
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          color: Colors.green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            " Log in",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget inputFile(
      {label, obscureText = false, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}