// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_test/dependency_injection.dart';
import 'package:supabase_test/supabase_provider.dart';
import 'package:supabase_test/supabase_test_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SupaBaseProvider supabaseProvider = inject<SupaBaseProvider>();

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController ageTextEditingController = TextEditingController();

  List<SupabaseTestData> supaBaseTestDataList = [];

  SupabaseTestData supabaseTestData = SupabaseTestData();


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
     await getData();
     setState(() {});
    });
    
    super.initState();
  }

  getData() async {
    supaBaseTestDataList = await supabaseProvider.getData() ?? [];
    log(supaBaseTestDataList.toString());
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                supabaseProvider.logOut();
              },
              icon: const Icon(Icons.logout))
        ],
        centerTitle: true,
        title: const Text("Home"),
        backgroundColor: Colors.blueAccent.shade100,
      ),
      backgroundColor: Colors.yellow.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
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
              Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: nameTextEditingController,
                        // validator: (value) {
                        //   if(value=="" || value==null){
                        //     return "Name is Required";
                        //   }else{
                        //     return null;
                        //   }
                        // },
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
                          hintText: 'Name',
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Age',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: ageTextEditingController,
                        // validator: (value) {
                        //   if(value=="" || value==null){
                        //     return "Age is Required";
                        //   }else{
                        //     return null;
                        //   }
                        // },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
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
                          hintText: 'Age',
                        ),
                      ),
                      const SizedBox(height: 35),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                      
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.all(4)),
                            onPressed: () async {
                              final name = nameTextEditingController.text.trim();
                              final age = ageTextEditingController.text.trim();
                              final result = await supabaseProvider.addData(
                                  name: name, age: int.tryParse(age));
                              if (result != null) {
                                supaBaseTestDataList.add(result);
                                setState(() { });
                                nameTextEditingController.clear();
                                ageTextEditingController.clear();
                                log(result.toJson().toString());
                                ScaffoldMessenger.of(context).showSnackBar( supabaseProvider.snackBar("Success", false));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar( supabaseProvider.snackBar("Error", true));
                              }
                            },
                            child: const Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.all(4)),
                            onPressed: () async {
                                final name = nameTextEditingController.text.trim();
                              final age = ageTextEditingController.text.trim();
                              final result = await supabaseProvider.updateData(id: supabaseTestData.id,
                                  name: name, age: int.tryParse(age));
                              if (result != null) {
                               supaBaseTestDataList = supaBaseTestDataList.map((element) => element.id== result.id?result:element).toList();
                                setState(() { });
                                nameTextEditingController.clear();
                                ageTextEditingController.clear();
                                log(result.toJson().toString());
                                ScaffoldMessenger.of(context).showSnackBar( supabaseProvider.snackBar("Success", false));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar( supabaseProvider.snackBar("Error", true));
                              }
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12,),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: const EdgeInsets.all(4)),
                            onPressed: () async {
                              final result = await supabaseProvider.deleteData(id: supabaseTestData.id,);
                              if (result != null) {
                                supaBaseTestDataList.removeWhere((element) => element.id ==result.id);
                                setState(() { });
                                nameTextEditingController.clear();
                                ageTextEditingController.clear();
                                log(result.toJson().toString());
                                ScaffoldMessenger.of(context).showSnackBar( supabaseProvider.snackBar("Success", false));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar( supabaseProvider.snackBar("Error", true));
                              }
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                          ),
                      const Spacer(),
                       SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                padding: const EdgeInsets.all(4)),
                            onPressed: () async {
                                nameTextEditingController.clear();
                                ageTextEditingController.clear();
                            },
                            child: const Text(
                              'Clear',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 100,
                  border: TableBorder.all(),
                  clipBehavior: Clip.hardEdge,
                  columns: const [
                    // DataColumn(label: Text("ID")),
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Age")),
                ], rows:  [
                  ...supaBaseTestDataList.map((e) => DataRow(
                    onLongPress: () {
                      nameTextEditingController.text = e.name.toString();
                      ageTextEditingController.text = e.age.toString();
                      supabaseTestData = e;
                      setState(() { });
                    },
                  
                  cells: [
                  DataCell(Text(e.name.toString()),),
                  DataCell(Text(e.age.toString()),),
                   
                  ]))
                ]),
              ),
              const SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}
