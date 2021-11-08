import 'package:dora/shared/cubit/block_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Layout/home_layout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home_layout(),
    );
  }
}
