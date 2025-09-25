import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // change if needed
      body: Center(
        child: SizedBox(
          height: 150,
          width: 150,
          child: Lottie.asset('assets/loading.json'),
        ),
      ),
    );
  }
}
