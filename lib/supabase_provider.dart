// ignore_for_file: public_member_api_docs, sort_constructors_first, empty_catches




import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupaBaseProvider extends ChangeNotifier {
  SupaBaseProvider({
    required this.supabaseClient,
    required this.googleSignIn,
  });
  final SupabaseClient supabaseClient;
  final GoogleSignIn googleSignIn;




  User? _user;

  User? get user => _user;

  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> loginWithGoogle() async {
    try {
      isLoading = true;
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      final result = await supabaseClient.auth.signInWithIdToken(
      accessToken: accessToken,provider: OAuthProvider.google, idToken: idToken!);
      user = result.session?.user;
      isLoading = false;
      if(user !=null){
        return true;
      }else {
        return false;
      }
    } on Exception {
      user = null;
      isLoading = false;
      return false;
    }
  }

   Future<bool> loginWithEmail(String email,String password) async {
    try {
       isLoading = true;
      final result = await supabaseClient.auth.signInWithPassword(password: password,email: email);
      user = result.session?.user;
      isLoading = false;
      if(user !=null){
        return true;
      }else {
        return false;
      }
    } on Exception {
      user = null;
      isLoading = false;
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email,String password) async {
    try {
      isLoading = true;
      await supabaseClient.auth.signUp(password: password,email: email);
      isLoading = false;
      return true;
    } on Exception {
      user = null;
      isLoading = false;
      return false;
    }
  }

  void logOut() {
    try {
      googleSignIn.signOut();
      supabaseClient.auth.signOut();
      user = null;
    } on Exception {}
  }

  void authChange() {
    user = supabaseClient.auth.currentUser;
    supabaseClient.auth.onAuthStateChange.listen((data) {
      user = data.session?.user;
    });
  }

 SnackBar snackBar(String value,bool isError) {
    return SnackBar(
      backgroundColor:isError?Colors.redAccent: Colors.green,
      content: Text(value),
    );
  }

}
