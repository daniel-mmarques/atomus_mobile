import 'package:atomus/pages/splashScreen.dart';

import 'package:flutter/material.dart';

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atomus',
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
    );
  }
}
