import 'package:chatapp_firebase/pages/appointment_page.dart';
import 'package:chatapp_firebase/pages/chat_list_page.dart';
import 'package:chatapp_firebase/pages/main_meny_page.dart';
import 'package:chatapp_firebase/pages/profile_page.dart';
import 'package:chatapp_firebase/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    MainMenu(),
    AppoinmentPage(),
    ChatListPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/home-ic.svg',
              color:
                  _selectedIndex == 0 ? Constants().primaryColor : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/nurse-ic.svg',
              color:
                  _selectedIndex == 1 ? Constants().primaryColor : Colors.grey,
            ),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/chat-ic.svg',
              color:
                  _selectedIndex == 2 ? Constants().primaryColor : Colors.grey,
            ),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/human-ic.svg',
              color:
                  _selectedIndex == 3 ? Constants().primaryColor : Colors.grey,
            ),
            label: 'Business',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Constants().primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
