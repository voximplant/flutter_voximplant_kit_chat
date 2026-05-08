import Flutter
import UIKit
import UserNotifications
import voximplant_kit_chat

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    private var foregroundNotificationPresenter: ForegroundNotificationPresenter?

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
        ensureForegroundPresentation()
    }

    private func ensureForegroundPresentation() {
        let center = UNUserNotificationCenter.current()
        if center.delegate is ForegroundNotificationPresenter {
            return
        }
        let presenter = ForegroundNotificationPresenter(wrapping: center.delegate)
        foregroundNotificationPresenter = presenter
        center.delegate = presenter
    }
}

private final class ForegroundNotificationPresenter: NSObject, UNUserNotificationCenterDelegate {
    private weak var wrappedDelegate: UNUserNotificationCenterDelegate?

    init(wrapping wrappedDelegate: UNUserNotificationCenterDelegate?) {
        self.wrappedDelegate = wrappedDelegate
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        wrappedDelegate?.userNotificationCenter?(center, willPresent: notification) { _ in }
        if VoximplantKitChatPlugin.isChatVisible() {
            completionHandler([])
        } else if #available(iOS 14.0, *) {
            completionHandler([.list, .banner, .sound])
        } else {
            completionHandler([.alert, .sound])
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let selector = #selector(
            UNUserNotificationCenterDelegate.userNotificationCenter(_:didReceive:withCompletionHandler:)
        )
        if let wrapped = wrappedDelegate, wrapped.responds(to: selector) {
            wrapped.userNotificationCenter?(center, didReceive: response, withCompletionHandler: completionHandler)
        } else {
            completionHandler()
        }
    }
}
