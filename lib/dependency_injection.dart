import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_test/env/env.dart';
import 'package:supabase_test/supabase_provider.dart';

final inject = GetIt.instance;

Future<void> setupDI() async {
  final supabaseClient = Supabase.instance.client;
  final googleSignIn = GoogleSignIn(serverClientId: Env.googleAuthClientId,);

  inject.registerSingleton(SupaBaseProvider(
      supabaseClient: supabaseClient, 
      googleSignIn: googleSignIn,
      ));
}
