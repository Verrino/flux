import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/services/authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late ColorPallete colorPallete;
  late SharedPreferences prefs;

  bool _isLoading = true;

  void loginUser() async {
    try {
      await AuthenticationService.login(
          _emailController.text, _passwordController.text);

      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.popAndPushNamed(context, 'insert');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    prefs = await SharedPreferences.getInstance().then((value) {
      colorPallete = value.getBool('isDarkMode') ?? false
          ? DarkModeColorPallete()
          : LightModeColorPallete();
      setState(() {
        _isLoading = false;
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: colorPallete.backgroundColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 50,
                      color: colorPallete.fontColor,
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      fillColor: colorPallete.textFieldColor,
                      hintText: 'Your Email',
                      hintStyle: TextStyle(
                        color: colorPallete.textFieldTextColor,
                        fontSize: 16,
                      ),
                    ),
                    style: TextStyle(color: colorPallete.fontColor),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: colorPallete.textFieldColor,
                      hintText: 'Your Password',
                      hintStyle: TextStyle(
                        color: colorPallete.textFieldTextColor,
                        fontSize: 16,
                      ),
                    ),
                    style: TextStyle(color: colorPallete.fontColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: colorPallete.textLinkColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(context, 'register');
                        },
                        child: Text(
                          'Don\'t have account?',
                          style: TextStyle(
                            color: colorPallete.textLinkColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      loginUser();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 60),
                      decoration: BoxDecoration(
                        color: colorPallete.buttonColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(color: colorPallete.fontColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
