import 'package:flutter/material.dart';
import 'package:listview/widgets/sidebar.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('halaman profile'),
      ),
      body: Center(
        child: Text('ini halaman profile'),
      ),
      drawer: Sidebar(),
    );
  }
}