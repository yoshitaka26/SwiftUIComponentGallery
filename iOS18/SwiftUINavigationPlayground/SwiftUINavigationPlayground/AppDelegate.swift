import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

    static let deepLinkNotification = Notification.Name("DeepLinkReceived")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        NotificationCenter.default.post(
                    name: Self.deepLinkNotification,
                    object: nil,
                    userInfo: ["screen": Screen.tres]
                )

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
}
