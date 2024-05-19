import 'package:estate_ease/Screens/property_list_screen.dart';
import 'package:estate_ease/Screens/sign_up_screen.dart';
import 'package:estate_ease/Widgets/container_for_input.dart';
import 'package:estate_ease/Widgets/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var _firebase = FirebaseAuth.instance;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  void validator() {
    if (_controllerEmail.text.trim().isEmpty ||
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
      // Validation successful
      _signIn();
    }
  }

  void _signIn() {
    try {
      final userCredential = _firebase.signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>  PropertyListScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Either email is not registered or password is incorrect'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estate Ease'),
        backgroundColor: Color.fromARGB(0, 11, 11, 227),
      ),
      body: Padding(
        padding: const EdgeInsets.all(.0),
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
                    ContainerForInput('Email', _controllerEmail,
                        icon: const Icon(Icons.email)),
                    const SizedBox(
                      height: 10,
                    ),
                    ContainerForInput('Password', _controllerPassword,
                        icon: const Icon(Icons.password)),
                    const SizedBox(
                      height: 10,
                    ),
                    SignInButton(
                      onPressed: validator,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text('Does not have account?'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'create an account',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
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
