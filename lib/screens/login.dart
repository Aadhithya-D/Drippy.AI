// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fashion_ai/app_theme.dart';
import 'package:fashion_ai/components/my_button.dart';
import 'package:fashion_ai/components/my_textfield.dart';
import 'package:fashion_ai/components/square_tile.dart';
import 'package:fashion_ai/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void wrongInfo(String error){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("InShorts Clone", style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
        content: Text(error, style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
        backgroundColor: Theme.of(context).colorScheme.background,
        titlePadding: const EdgeInsets.all(20),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("Ok", style: TextStyle(color: Theme.of(context).colorScheme.tertiary)))
        ],
      );
    });
  }

  // sign user in method
  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    }
    on FirebaseAuthException catch(e){
      Navigator.pop(context);
      if(e.code == "user-not-found"){
        wrongInfo(e.message.toString());
      }
      else if(e.code == "wrong-password"){
        wrongInfo(e.message.toString());
      }
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
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),

                    // logo
                    Icon(
                      Icons.lock,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 100,
                    ),

                    const SizedBox(height: 50),

                    // welcome back, you've been missed!
                    Text(
                      'Welcome back you\'ve been missed!',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),

                    const SizedBox(height: 25),

                    // email textfield
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

                    // forgot password?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // sign in button
                    MyButton(
                      text: "Sign In",
                      onTap: signUserIn,
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
                          onTap: () => AuthService().signInWithGoogle(),
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
                          'Not a member?',
                          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Register now',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
