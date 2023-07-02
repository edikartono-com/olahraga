import 'package:flutter/material.dart';
import 'package:olahraga/helper/dio_helper.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'register_screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final DioHelper _dioHelper = DioHelper();
  // bool _showPassword = false;

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing data'),
        backgroundColor: Colors.green.shade300,
      ));

      Map<String, dynamic> userData = {
        "username": usernameController.text,
        "password": passwordController.text,
        "email": emailController.text,
        "first_name": firstnameController.text
      };

      dynamic res = await _dioHelper.registerUser(userData);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res['ErrorCode'] == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen()
          )
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${res['message']}"),
            backgroundColor: Colors.red.shade300,
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Form(
        key: _formKey,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: firstnameController,
                      decoration: const InputDecoration(
                        hintText: "Full Name",
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        hintText: "Username",
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        isDense: true
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: registerUser,
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
