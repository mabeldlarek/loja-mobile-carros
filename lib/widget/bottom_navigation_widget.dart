import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatelessWidget {
  final List<Widget> buttons;

  const BottomNavigationWidget({
    Key? key,
    required this.buttons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.only(top: 1),
      child: BottomAppBar(
        height: 90,
        elevation: 0,
        color: Colors.blue,
        child: IconTheme(
          data: const IconThemeData(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ...buttons.expand((button) => [const SizedBox(width: 12), button]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
