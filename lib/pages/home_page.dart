// Packages
import 'package:flutter/material.dart';

// Pages
import '../pages/chats_page.dart';
import 'package:chatifyapp/pages/users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Page index
  int _currentPage = 0;
  // * Pages to display and navigate
  final List<Widget> _pages = [
    const ChatsPage(),
    const UsersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
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
        onTap: (_index) {
          setState(
            () {
              _currentPage = _index;
            },
          );
        },
      ),
    );
  }
}
