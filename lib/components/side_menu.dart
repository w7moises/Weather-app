import 'package:app_weather/components/info_card.dart';
import 'package:app_weather/components/side_menu_tile.dart';
import 'package:app_weather/models/river_assets.dart';
import 'package:app_weather/utils/rive.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  RiveModel selectedMenu = sideMenus.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: Color(0xFF17203A),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: InfoCard(name: "Walter Molina",description: "Demo App",),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24,top: 32,bottom: 16),
              child: Text("Browse".toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white70)),
            ),
           ...sideMenus.map(
                (menu) => SideMenuTile(
                  menu: menu,
                  riveonInit: (artboard) {
                    StateMachineController controller =
                        RiveUtils.getRiveController(artboard,
                            stateMachineName: menu.stateMachineName);
                    menu.status = controller.findSMI("active") as SMIBool;
                  },
                  press: () {
                    menu.status!.change(true);
                    Future.delayed(const Duration(seconds: 1), () {
                      menu.status!.change(false);
                    });
                    setState(() {
                      selectedMenu = menu;
                    });
                  },
                  isActive: selectedMenu == menu,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

