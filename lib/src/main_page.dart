import 'package:flutter/material.dart';
import 'package:subagent/src/view/board_view.dart';
import 'package:subagent/src/view/setting_view.dart';
import 'package:subagent/src/view/subagent_list_view.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedTabIndex = 0;
  List _pages = [SubagentListView(), BoardView(), SettingView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_selectedTabIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        currentIndex: _selectedTabIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: const Icon(Icons.search, color: Colors.grey),
              activeIcon: const Icon(Icons.search, color: Colors.blue),
              title: Text(
                '복대리',
                style: TextStyle(
                    color: _selectedTabIndex == 0 ? Colors.blue : Colors.grey),
              )),
          BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard, color: Colors.grey),
              activeIcon: const Icon(Icons.dashboard, color: Colors.blue),
              title: Text(
                '게시판',
                style: TextStyle(
                    color: _selectedTabIndex == 1 ? Colors.blue : Colors.grey),
              )),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings, color: Colors.grey),
              activeIcon: const Icon(Icons.settings, color: Colors.blue),
              title: Text(
                '설정',
                style: TextStyle(
                    color: _selectedTabIndex == 2 ? Colors.blue : Colors.grey),
              )),
        ],
      ),
    );
  }
}
