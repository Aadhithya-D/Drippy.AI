import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fashion_ai/app_theme.dart';
import 'package:fashion_ai/components/my_button.dart';
import 'package:fashion_ai/components/my_textfield.dart';
import 'package:fashion_ai/components/square_tile.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  // text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final db = FirebaseFirestore.instance;

  void wrongInfo(String error) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "InShorts Clone",
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
            content: Text(
              error,
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            titlePadding: const EdgeInsets.all(20),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok",
                      style: TextStyle(color: Theme.of(context).colorScheme.tertiary)))
            ],
          );
        });
  }

  void signUserUp() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (passwordController.text == confirmPasswordController.text) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            )
            .then((value) => {
                  FirebaseFirestore.instance
                      .collection("UserData")
                      .doc(value.user?.uid)
                      .set({
                    "name": nameController.text,
                    "email": value.user?.email,
                  })
                });
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        wrongInfo(e.message.toString());
      }
    } else {
      Navigator.pop(context);
      wrongInfo("Passwords don't match!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 70,
                  ),

                  const SizedBox(height: 25),

                  Text(
                    'Let\'s create an account for you!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: nameController,
                    hintText: 'Name',
                    obscureText: false,
                    type: TextInputType.name,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    type: TextInputType.emailAddress,
                    icon: Icons.email,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    type: TextInputType.visiblePassword,
                    icon: Icons.key,
                  ),

                  const SizedBox(height: 10),

                  // confirm password textfield
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    type: TextInputType.visiblePassword,
                    icon: Icons.key,
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    text: "Sign Up",
                    onTap: signUserUp,
                  ),
                  const SizedBox(height: 25),
                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // google + apple sign in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      SquareTile(
                        imagePath: 'lib/images/google.png',
                        onTap: () => AuthService().signUpWithGoogle(),
                      ),

                      // SizedBox(width: 25),
                      //
                      // // apple button
                      // SquareTile(imagePath: 'lib/images/apple.png')
                    ],
                  ),

                  const SizedBox(height: 50),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Login now',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
