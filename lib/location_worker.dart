// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:new_backgroud_service_project/main.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:geolocator/geolocator.dart';

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     print(' callbackDispatcher fun : $inputData');
//     fetchLocation(navigatorKey.currentContext!);
//     return Future.value(true);
//   });
// }

// void registerLocationWorker() {
//   Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
//   Workmanager().registerPeriodicTask(
//     'locationTask',
//     'locationWorker',
//     frequency: const Duration(minutes: 15),
//   );
// }

// // void fetchLocation() async {
// //   print(' fetchLocation fun ');
// //   final Position position = await Geolocator.getCurrentPosition(
// //       desiredAccuracy: LocationAccuracy.high);

// //   print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
// // }
// void fetchLocation(BuildContext context) async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   // Check if location services are enabled
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   print(' fetchLocation fun : $serviceEnabled');
//   if (!serviceEnabled) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Location Services Disabled'),
//         content: const Text(
//             'Please enable location services to fetch the location.'),
//         actions: [
//           TextButton(
//             child: const Text('OK'),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     );
//     return;
//   }

//   // Request location permission
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Location Permissions Denied'),
//           content: const Text(
//               'Please grant location permissions to fetch the location.'),
//           actions: [
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       );
//       return;
//     }
//   }

//   if (permission == LocationPermission.deniedForever) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Location Permissions Denied'),
//         content: const Text(
//             'Location permissions are permanently denied. Please enable them from the device settings.'),
//         actions: [
//           TextButton(
//             child: const Text('OK'),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     );
//     return;
//   }

//   // Fetch the location
//   try {
//     final Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
//   } catch (e) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Error'),
//         content: const Text('An error occurred while fetching the location.'),
//         actions: [
//           TextButton(
//             child: const Text('OK'),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:geolocator/geolocator.dart';

Future fetchLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  print(' fetchLocation fun : $serviceEnabled');
  if (!serviceEnabled) {
    await Geolocator.requestPermission();

    return;
  }

  // Request location permission
  permission = await Geolocator.checkPermission();
  print(' fetchLocation fun permissiom : $permission');
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print(' fetchLocation LocationPermission.denied if');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print(' fetchLocation LocationPermission.deniedForever if');
    return;
  }

  // Fetch the location
  try {
    print('Fetch the location');
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  } catch (e) {
    print('getlocation permission $e');
  }
}

Future requestPermisstion() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  print(' fetchLocation fun : $serviceEnabled');
  if (!serviceEnabled) {
    await Geolocator.requestPermission();

    return;
  }

  // Request location permission
  permission = await Geolocator.checkPermission();
  print(' fetchLocation fun permissiom : $permission');
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (!(permission == LocationPermission.always)) {
      print(' fetchLocation LocationPermission.denied if');
      await Geolocator.openAppSettings();
      return;
    }
  }

  // if () {
  //   print(' fetchLocation LocationPermission.deniedForever if');
  //   return;
  // }
  //  if (permission == LocationPermission.always) {
  //   print(' fetchLocation LocationPermission.deniedForever if');
  //   return;
  // }
}
