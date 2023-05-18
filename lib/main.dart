import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_backgroud_service_project/app_lifecycle_tracker.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

import 'location_worker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermisstion();
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  return runApp(MyApp());
}

const simplePeriodicTask =
    "be.tramckrijte.workmanagerExample.simplePeriodicTask";

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  print("callbackDispatcher fun");
  Workmanager().executeTask((task, inputData) async {
    print("callbackDispatcher fun executeTask");

    switch (task) {
      case simplePeriodicTask:
        await fetchLocation();
        print("$simplePeriodicTask was executed");
        break;

      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        // Directory? tempDir = await getTemporaryDirectory();
        // String? tempPath = tempDir.path;
        // print(
        //     "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
        break;
    }

    return Future.value(true);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter WorkManager Example"),
        ),
        body: AppLifecycleTracker(
          didChangeAppState: (state) async {
            print('app state  $state : ${state.name}');
            if (state == AppState.resumed) {
              // LocationPermission permission =
              await Geolocator.checkPermission().then((permission) async {
                print('app state permission $permission');
                if (permission == LocationPermission.always) {
                  if (Platform.isAndroid) {
                    await Workmanager().registerPeriodicTask(
                      simplePeriodicTask,
                      simplePeriodicTask,
                      initialDelay: const Duration(seconds: 3),
                      frequency: const Duration(seconds: 10),
                    );
                  } else if (Platform.isIOS) {
                    Workmanager().registerOneOffTask(
                      "task-identifier",
                      "simpleTaskKey", // Ignored on iOS
                      // initialDelay: Duration(minutes: 30),
                      constraints: Constraints(
                        // connected or metered mark the task as requiring internet
                        networkType: NetworkType.connected,
                        // require external power
                        requiresCharging: true,
                      ),
                    );
                  }
                } else {
                  print('app state permission $permission');
                  await Geolocator.openAppSettings();
                }
              });
            }
          },
          child: layout(),
        ),
      ),
    );
  }

  SingleChildScrollView layout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //This task runs periodically
            //It will wait at least 10 seconds before its first launch
            //Since we have not provided a frequency it will be the default 15 minutes
            ElevatedButton(
                onPressed: Platform.isAndroid
                    ? () {
                        print('Register Periodic Task (Android)');
                        // log("Register Periodic Task Android".toString());
                        Workmanager().registerPeriodicTask(
                          simplePeriodicTask,
                          simplePeriodicTask,
                          // initialDelay: const Duration(seconds: 3),
                        );
                      }
                    : null,
                child: const Text("Register Periodic Task (Android)")),

            ElevatedButton(
              child: const Text("Cancel All"),
              onPressed: () async {
                // await Workmanager().cancelAll();
                fetchLocation();
                print('Cancel all tasks completed');
              },
            ),
          ],
        ),
      ),
    );
  }
}
