import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications
import FirebaseMessaging
import Firebase


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate ,MessagingDelegate{
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDHluaVdLhjnj_5qgqgy4h4Ah-daCuhOPo")
      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
             GeneratedPluginRegistrant.register(with: registry)
         }
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

         if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

         GeneratedPluginRegistrant.register(with: self)
         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
