import 'package:rive/rive.dart';

class RiveModel {
  final String src, artboard, stateMachineName,title;
  late SMIBool? status;

  RiveModel({
    required this.src,
    required this.artboard,
    required this.stateMachineName,
    required this.title,
    this.status, 
  });

  set setStatus(SMIBool state) {
    status = state;
  }
}

 List<RiveModel> sideMenus = [
    RiveModel(
      src: "assets/riveAssets/icons.riv", 
      artboard: "HOME", 
      stateMachineName: "HOME_interactivity",
      title:"Home"
    ),
    RiveModel(
      src: "assets/riveAssets/icons.riv", 
      artboard: "SEARCH", 
      stateMachineName: "SEARCH_Interactivity",
      title:"Search"
    ),
    RiveModel(
      src: "assets/riveAssets/icons.riv", 
      artboard: "LIKE/STAR", 
      stateMachineName: "STAR_Interactivity",
      title:"Favorites"
    ),
 ];