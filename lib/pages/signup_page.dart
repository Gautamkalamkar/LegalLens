import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legallens/main.dart';
import 'package:legallens/pages/login_page.dart';
import 'package:lottie/lottie.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SignUp failed: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset(
                'assets/animations/register.json',
              ),
              SizedBox(
                height: size.width * 0.1,
              ),
              Text(
                'Register Yourself',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.06,
                    fontFamily: 'Lexend'),
              ),
              SizedBox(
                height: size.width * 0.02,
              ),
              Text('Create an account. It\'s free'),
              SizedBox(
                height: size.width * 0.09,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  fillColor: Colors.blue,
                  hintText: 'Enter your Email here',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(
                height: size.width * 0.05,
              ),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                    fillColor: Colors.blue,
                    hintText: 'Enter your password here',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off))),
              ),
              SizedBox(
                height: size.width * 0.12,
              ),
              SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      await createUserWithEmailAndPassword();
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.all(15.0),
                        backgroundColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    child: Text('Sign Up'),
                  )),
              SizedBox(
                height: size.width * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  TextButton(
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text('Sign In'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
