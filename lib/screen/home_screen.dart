import 'package:donation_nature/action/action.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    MainAction _mainAction = MainAction();

    return Scaffold(
      appBar: AppBar(
        title: Text("내 위치"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          //
          onPressed: _mainAction.getAddress,
          child: const Text('Get Address'),
        ),
      ),
    );
  }
}
