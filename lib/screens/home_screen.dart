import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_movie_app/constant/style.dart';
import 'package:flutter_movie_app/screens/error_page.dart';
import 'package:flutter_movie_app/screens/map_screen.dart';
import 'package:flutter_movie_app/screens/movie_screen.dart';
import 'package:flutter_movie_app/screens/tv_screen.dart';
import 'package:flutter_movie_app/screens/watch_lists_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool ActiveConnection = false;
  String T = "";
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  @override
  void initState() {
    CheckUserConnection();
    super.initState();
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    CheckUserConnection();
    PageController _controller = PageController();
    void onTapIcon(int index) {
      _controller.animateToPage(index,
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    }

    return Scaffold(
      appBar: _currentIndex != 2
          ? AppBar(
              centerTitle: true,
              title: _buildTitle(_currentIndex),
            )
          : null,
      body: !ActiveConnection
          ? const ErrorScreen()
          : PageView(
              controller: _controller,
              children: const [
                MovieScreen(),
                TVsScreen(),
                WatchLists(),
                MapScreen(),
              ],
              onPageChanged: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Style.primaryColor,
        selectedItemColor: Style.secondColor,
        unselectedItemColor: Style.textColor,
        onTap: onTapIcon,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movies"),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: "TVs"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Watch Lists"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Location"),
        ],
      ),
    );
  }

  _buildTitle(int _index) {
    switch (_index) {
      case 0:
        return const Text('Movie Shows');
      case 1:
        return const Text('TV Shows');
      default:
        return null;
    }
  }
}
