import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'store_provider.dart';
import 'store_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Store Locator',
      home: StoreScreen(),
    );
  }
}
