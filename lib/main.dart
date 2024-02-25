import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_test/dependency_injection.dart';
import 'package:supabase_test/env/env.dart';
import 'package:supabase_test/home_screen.dart';
import 'package:supabase_test/loader.dart';
import 'package:supabase_test/login_screen.dart';
import 'package:supabase_test/supabase_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Env.apiUrl,
    anonKey: Env.apiKey,
  );

  await setupDI();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SupaBaseProvider supabaseProvider = inject<SupaBaseProvider>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ ChangeNotifierProvider(create: (_) => supabaseProvider),],
      child: MaterialApp(
        title: 'Supabase Test',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const SignInBuilder(),
        builder: (BuildContext context, Widget? child) => AppLoader(child: child),
      ),
    );
  }
}

class SignInBuilder extends StatefulWidget {
  const SignInBuilder({
    super.key,
  });


  @override
  State<SignInBuilder> createState() => _SignInBuilderState();
}

class _SignInBuilderState extends State<SignInBuilder> {
SupaBaseProvider supabaseProvider = inject<SupaBaseProvider>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {supabaseProvider.authChange(); });
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: supabaseProvider,
      builder: (context, snapshot) {
        return Builder(builder: (context) {
          if (supabaseProvider.user != null) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        });
      },child: widget,
    );
  }
}
