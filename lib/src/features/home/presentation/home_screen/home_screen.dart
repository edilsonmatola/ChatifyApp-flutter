// Packages
import 'package:flutter/material.dart';

// Pages
import '../../../contacts/contacts_export.dart';
import '../../../groups/presentation/group_screen/chats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Page index
  int _currentPage = 0;
  // * Pages to display and navigate
  final List<Widget> _pages = [
    const ChatsScreen(),
    const UsersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        items: const [
          BottomNavigationBarItem(
            label: 'CHATS',
            icon: Icon(
              Icons.chat_bubble_sharp,
            ),
          ),
          BottomNavigationBarItem(
            label: 'USERS',
            icon: Icon(
              Icons.supervised_user_circle,
            ),
          ),
        ],
        onTap: (index) {
          setState(
            () {
              _currentPage = index;
            },
          );
        },
      ),
    );
  }
}
