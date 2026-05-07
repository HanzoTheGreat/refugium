import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: RefugiumApp()));
}

class RefugiumApp extends StatelessWidget {
  const RefugiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refugium',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('Refugium'))),
    );
  }
}
