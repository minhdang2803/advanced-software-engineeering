import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/profile_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/widgets.dart';

class AppoinmentPage extends StatefulWidget {
  const AppoinmentPage({super.key});

  @override
  State<AppoinmentPage> createState() => _AppoinmentPageState();
}

class _AppoinmentPageState extends State<AppoinmentPage> {
  var size, width;
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  String groupName = "";

  List<Doctor> doctor = [
    Doctor("John", "Anesthesiologists", "7"),
    Doctor("Anderson", "Cardiologists", "10"),
    Doctor("John Cena", "Dermatologists", "11"),
    Doctor("David Beckham", "Endocrinologists", "12"),
    Doctor("Khoa Pug", "Gastroenterologists", "9"),
    Doctor("Johnny Dang", "Hematologists", "13"),
  ];

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await gettingUserData();
              // ignore: use_build_context_synchronously
              nextScreen(
                  context, ProfilePage(email: email, userName: userName));
            },
            icon: Image.asset('assets/person.png'),
          )
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Appoinments",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: doctor.length,
            itemBuilder: (context, index) {
              final item = doctor[index];

              return Container(
                height: 150,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFF43969C),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 17,
                      left: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0), //or 15.0
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          color: Colors.grey.shade100,
                          child: const Image(
                            image: AssetImage('assets/doctor.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 27,
                      left: 70,
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 60),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF43969C)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: const BorderSide(
                                      color: Color(0xFF43969C),
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Book',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 20,
                      child: Text(
                        'Working on ${item.department}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 20,
                      child: Text(
                        'Have ${item.yoe} years of experience',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Doctor {
  Doctor(this.name, this.department, this.yoe);
  String name;
  String department;
  String yoe;
}
