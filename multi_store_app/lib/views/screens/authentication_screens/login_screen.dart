import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/controllers/auth_controller.dart';
import 'package:multi_store_app/global_variables.dart';

import 'login_decoration_dot.dart';
import 'login_textField.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final AuthController authController = AuthController();
  late String email;
  late String password;
  bool isLoading = false;

  loginUser() async {
    setState(() {
      isLoading = true;
    });
    await authController
        .signInUsers(
          context: context,
          email: email,
          password: password,
          ref: ref,
        )
        .whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login Your Account",
                    style: GoogleFonts.lato(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0d120E),
                      letterSpacing: 0.2,
                    ),
                  ),

                  Image.asset(
                    "assets/imgs/Illustration.png",
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),

                  LoginTextField(
                    title: "Email",
                    labelText: "enter your email",
                    iconPath: "assets/icons/email.png",
                    enterErrol: "enter you email",
                    onChanged: (value) {
                      email = value;
                    },
                  ),

                  SizedBox(height: 20),

                  LoginTextField(
                    title: "Password",
                    labelText: "enter your password",
                    iconPath: "assets/icons/password.png",
                    suffixIcon: Icon(Icons.visibility),
                    enterErrol: "enter your password",
                    onChanged: (value) {
                      password = value;
                    },
                  ),

                  SizedBox(height: 20),

                  InkWell(
                    onTap: () async {
                      if (formKey.currentState!.validate()) loginUser();
                    },
                    child: Container(
                      width: 319,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                          colors: [Color(0xFF102DE1), Color(0xCC0D6EFF)],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 279,
                            top: 19,
                            child: Opacity(
                              opacity: 0.5,
                              child: Container(
                                width: 60,
                                height: 60,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 12,
                                    color: Color(0xFF103DE5),
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),

                          LoginDecorationDot(
                            left: 311,
                            top: 36,
                            size: 5,
                            circular: 3,
                          ),

                          LoginDecorationDot(
                            left: 281,
                            top: -10,
                            size: 20,
                            circular: 10,
                          ),

                          Center(
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Sign in",
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Need an Account?",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, regitserRoute);
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.roboto(
                            color: Color(0xFF103DE5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
