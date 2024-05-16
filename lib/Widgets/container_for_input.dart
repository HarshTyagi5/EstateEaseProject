import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ContainerForInput extends StatelessWidget {
  ContainerForInput(this.text, this._controller, {super.key, this.icon});

  String text;
  var icon;
  final TextEditingController _controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: icon,
          border: const OutlineInputBorder(),
          label: Text(text),
        ),
        controller: _controller,
        obscureText: text == 'Password' ? true : false,
        keyboardType: text == 'Password'
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
      ),
    );
  }
}
