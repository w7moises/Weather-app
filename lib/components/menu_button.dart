import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key, required this.press, required this.riveonInit,
  }) : super(key: key);

  final VoidCallback press;
  final ValueChanged<Artboard> riveonInit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: press,
        child: Container(
          margin: EdgeInsets.only(left: 16),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black12,offset: Offset(0,3),blurRadius: 8),
            ],
          ),
          child: RiveAnimation.asset("assets/riveAssets/menu_button.riv",
            onInit: riveonInit,
          ),
        ),
      ),
    );
  }
}