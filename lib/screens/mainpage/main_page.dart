import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  final Widget child;
  const MainPage({super.key, required this.child});

  @override
  State<MainPage> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  final List<String> _currentNavigationItemsByName = [
    'home',
    'journal',
    'settings',
  ];

  int getCurrentIndex() {
    GoRouter router = GoRouter.of(context);
    final String currentRouteName = router.state.name ?? '';
    print(currentRouteName);

    var idx = _currentNavigationItemsByName.indexOf(currentRouteName);
    return idx >= 0 ? idx : 0;

    // final String location = router.state.uri.path;
    // if (location.startsWith('/home')) {
    //   return 0;
    // } else if (location.startsWith('/events')) {
    //   return 1;
    // } else if (location.startsWith('/mycharges')) {
    //   return 2;
    // } else if (location.startsWith('/vehicle-bookings')) {
    //   return 3;
    // }
    //return 0; // Default to home if no match
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: widget.child),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: getCurrentIndex(),
        selectedItemColor: const Color.fromARGB(255, 8, 8, 8),
        onTap: (index) {
          print(index);
          context.go('/${_currentNavigationItemsByName[index]}');
        },
      ),
    );
  }
}
