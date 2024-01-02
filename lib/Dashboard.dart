import 'package:flutter/material.dart';
import 'package:test_agora/onetooneVideo.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: TextButton(
            child: const Text('Call One to One'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OneToOneLiveScreen(),
                ),
              );
            },),
      ),
    );
  }
}
