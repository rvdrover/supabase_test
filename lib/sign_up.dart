// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_test/supabase_provider.dart';

import 'dependency_injection.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
        title: const Text("Sign up"),backgroundColor: Colors.blueAccent.shade100,),
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
                              final result = await supabaseProvider.signUpWithEmail(email, password);
                              if(result){
                                Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(supabaseProvider.snackBar("Success",false));
                             }else{
                               ScaffoldMessenger.of(context).showSnackBar(supabaseProvider.snackBar("Error",true));
                             }
                            }, child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                          ),
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