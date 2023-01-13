import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key, required this.name, required this.description,
  }) : super(key: key);

  final String name, description;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name,
      style: const TextStyle(color: Colors.white)),
      subtitle: Text(description,
      style: const TextStyle(color: Colors.white)),
      leading: const CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(
          CupertinoIcons.person,
          color: Colors.white,
        ),
      ),
    );
  }
} 