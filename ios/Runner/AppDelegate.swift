import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    var mapsApiKey = ProcessInfo.processInfo.environment["MAPS_API_KEY"]
    if mapsApiKey == nil {
        mapsApiKey = "AIzaSyBh3_H0VFIXposNxR0HZcW4-ee5XPTbtdc"
    }
    GMSServices.provideAPIKey(mapsApiKey!)
    // if #available(iOS 10.0, *) {
    //   UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    // }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
