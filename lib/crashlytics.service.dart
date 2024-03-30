import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

class CrashlyticsService extends GetxService {
  // define
  static CrashlyticsService get to => Get.find();

  // Toggle this for testing Crashlytics in your app locally.
  final bool kTestingCrashlytics;

  // Constrictor
  CrashlyticsService({
    this.kTestingCrashlytics = false,
  });

  // initialization
  Future<CrashlyticsService> init() async {
    if (kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kTestingCrashlytics);
    }

    // Pass all uncaught errors to Crashlytics.
    Function? originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError!(errorDetails);
    };

    return this;
  }

  //Report Exception with stackTrace
  Future<void> reportError(
    dynamic exception,
    StackTrace stack,
  ) async {
    print('exception $exception');
    print('stack $stack');
    await FirebaseCrashlytics.instance.recordError(exception, stack);
  }

  //report Flutter error
  Future<void> reportFlutterError(FlutterErrorDetails error) async {
    await FirebaseCrashlytics.instance.recordFlutterError(error);
  }

  //report log a one single message
  Future<void> log(dynamic error) async {
    FirebaseCrashlytics.instance.log(error);
  }
}
