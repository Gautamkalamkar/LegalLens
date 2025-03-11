import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/login.png'),
            Text('Welcome back'),
            Text('Sign in to continue your journey'),
            TextField(),
            TextField(),
            ElevatedButton(onPressed: () {}, child: Text('Sign In')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                TextButton(onPressed: () {}, child: Text('Sign Up'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
