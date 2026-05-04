import 'package:flutter/material.dart';

void main() {
  runApp(const MoveCity());
}

class MoveCity extends StatelessWidget {
  const MoveCity({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoveCity',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('MoveCity'),
        ),
        body: Center(
          child: Text('MoveCity'),
        ),
      ),
    );
  }
}
