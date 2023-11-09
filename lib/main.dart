import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_view.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AppData(),
      child: const MaterialApp(home: HomeView())));
}
