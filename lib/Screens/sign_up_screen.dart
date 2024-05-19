import 'package:estate_ease/Screens/property_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:estate_ease/Widgets/container_for_input.dart';

import 'package:flutter/material.dart';

var _firebase = FirebaseAuth.instance;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _controllerUser = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  void _createUserAccount() async {
    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return  PropertyListScreen();
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email already in use')));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication Failed!'),
        ),
      );
      }
      
    }
  }

  void _validator() {
    if (_controllerUser.text.trim().isEmpty ||
        _controllerUser.text.trim().length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User Name not valid'),
        ),
      );
    } else if (_controllerEmail.text.trim().isEmpty ||
        !_controllerEmail.text.contains('@') ||
        !_controllerEmail.text.contains('.') ||
        _controllerEmail.text.length < 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter Valid Email'),
        ),
      );
    } else if (_controllerPassword.text.isEmpty ||
        _controllerPassword.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
        ),
      );
    } else {
      _createUserAccount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estate Ease'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Stack(
            children: [
              Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/estate_ease.png',
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ContainerForInput('UserName', _controllerUser),
                    const SizedBox(
                      height: 8,
                    ),
                    ContainerForInput('Email', _controllerEmail),
                    const SizedBox(
                      height: 8,
                    ),
                    ContainerForInput('Password', _controllerPassword),

                    // sign up button

                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      child: ElevatedButton(
                        onPressed: _validator,
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: const Text('Sign up'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
