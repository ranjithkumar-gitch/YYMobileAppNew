import 'package:flutter/material.dart';

class AdvstScreen extends StatefulWidget {
  const AdvstScreen({super.key});

  @override
  State<AdvstScreen> createState() => _AdvstScreenState();
}

class _AdvstScreenState extends State<AdvstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Work In Progress'),
      ),
    );
  }
}
