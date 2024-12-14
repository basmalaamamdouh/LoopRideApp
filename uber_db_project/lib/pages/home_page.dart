import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../globall/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> googlMapCompletercontroller = Completer<GoogleMapController>();
  GoogleMapController? controllerGooglemap;
  late Position currentPositionOfUser;

  void updateMapTheme(GoogleMapController controller)
  {
    getJsonFileFromThemes("themes/night_style.json").then((value)=> setGoogleMapStyle(value,controller));
  }
  Future <String> getJsonFileFromThemes(String mapStylePath)async
  {
    var byteData =await rootBundle.load(mapStylePath);
    var List =byteData.buffer.asInt8List(byteData.offsetInBytes,byteData.lengthInBytes);
    return utf8.decode(List);
  }
  setGoogleMapStyle(String googleMapStyle,GoogleMapController controller)
  {
    controller.setMapStyle(googleMapStyle);
  }

  getCurrentLiveLocation()async
  {
    Position positionOfUser = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfUser = positionOfUser;
    LatLng positionOfUserInLatLng= LatLng(currentPositionOfUser!.latitude,currentPositionOfUser!.longitude);
    CameraPosition cameraposition =CameraPosition(target: positionOfUserInLatLng,zoom: 15);
    controllerGooglemap!.animateCamera(CameraUpdate.newCameraPosition(cameraposition));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType:MapType.normal ,
            myLocationButtonEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController)
            {
              controllerGooglemap=mapController;
              updateMapTheme(controllerGooglemap!);
              googlMapCompletercontroller.complete(controllerGooglemap);
              getCurrentLiveLocation();
            },
          ),
        ],
      ),
    );
  }
}
