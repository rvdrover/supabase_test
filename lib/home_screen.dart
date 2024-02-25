import 'package:flutter/material.dart';
import 'package:supabase_test/dependency_injection.dart';
import 'package:supabase_test/supabase_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SupaBaseProvider supabaseProvider = inject<SupaBaseProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Center(
              child: Text(
                "Hello",
                style: TextStyle(fontSize: 38, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(4)),
                onPressed: () {
                  supabaseProvider.logOut();
                },
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
