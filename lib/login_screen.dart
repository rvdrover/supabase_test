// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_test/sign_up.dart';
import 'package:supabase_test/supabase_provider.dart';

import 'dependency_injection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SupaBaseProvider  supabaseProvider = inject<SupaBaseProvider>();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isPassHide = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login"),backgroundColor: Colors.blueAccent.shade100,),
          backgroundColor: Colors.yellow.shade100,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: emailTextEditingController,
                            validator: (value) {
                              if(value=="" || value==null){
                                return "Email is Required";
                              }else{
                                return null;
                              } 
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                strokeAlign: BorderSide.strokeAlignOutside,
                              )),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.black,
                              ),
                              hintText: 'Email',
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            obscureText: isPassHide,
                            controller: passwordTextEditingController,
                            validator: (value) {
                              if(value=="" || value==null){
                                return "Password is Required";
                              }else if(value.length < 6){
                                return "Password must be more than 6 characters";
                                }else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPassHide = !isPassHide;
                              });
                            },
                            child:  Icon(isPassHide ?Icons.visibility_off :Icons.visibility),
                          ),
                          fillColor: Colors.white,
                              filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                strokeAlign: BorderSide.strokeAlignOutside,
                              )),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              hintText: 'Password',
                            ),
                          ),
                          const SizedBox(height: 35),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,padding: const EdgeInsets.all(4)),
                              onPressed: () async {
                               if(!_formKey.currentState!.validate()){
                                return;
                               }
                               final email = emailTextEditingController.text.trim();
                               final password = passwordTextEditingController.text.trim();
                               final result =await supabaseProvider.loginWithEmail(email, password);
                            if(result){
                              ScaffoldMessenger.of(context).showSnackBar(supabaseProvider.snackBar("Success",false));
                             }else{
                               ScaffoldMessenger.of(context).showSnackBar(supabaseProvider.snackBar("Error",true));
                             }
                            }, child: const Text(
                                      'Log In',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                          ),
                           const SizedBox(height: 15),
                          Center(
                        child: RichText(
                            text: TextSpan(
                          children:  [
                            TextSpan(
                              text: "Create Account",
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const SignUpScreen(),
                                ),
                              );
                            },
                            )
                          ],
                          text: "Don't have a Account? ",
                          style: const TextStyle(color: Colors.black),
                        )),
                          ),
                          const SizedBox(height: 15),
                          const Center(
                            child: Text(
                              '- Or Sign In with -',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final result =  await supabaseProvider.loginWithGoogle();
                                  if(result){
                                    ScaffoldMessenger.of(context).showSnackBar(supabaseProvider.snackBar("Success",false));
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(supabaseProvider.snackBar("Error",true));
                                  }

                                },
                                child: const FaIcon(FontAwesomeIcons.google,size: 38,color: Colors.red),
                              ),
                              // const SizedBox(width: 20),
                              // GestureDetector(
                              //   onTap: () {
                                  
                              //   },
                              //   child: const FaIcon(FontAwesomeIcons.facebook,size: 38,color: Colors.blue,),
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
  }
  
}