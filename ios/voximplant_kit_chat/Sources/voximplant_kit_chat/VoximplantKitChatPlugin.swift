import Flutter
import UIKit
import VoximplantKitChatUI

public final class VoximplantKitChatPlugin: NSObject, FlutterPlugin, VoximplantKitChatApi, VIKitChatViewControllerDelegate {
    private var viKitChatUI: VIKitChatUI?
    private var flutterApi: VoximplantKitChatFlutterApi?
    private var kitChatCustomization = VIKitChatUICustomization()


    private var isDevelopmentPushToken: Bool {
        #if DEBUG
        true
        #else
        false
        #endif
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = VoximplantKitChatPlugin()
        instance.flutterApi = VoximplantKitChatFlutterApi(binaryMessenger: registrar.messenger())
        VoximplantKitChatApiSetup.setUp(binaryMessenger: registrar.messenger(), api: instance)
    }

    func initialize(credentials: KitChatCredentials) throws {
        guard
            let viKitChatUI = VIKitChatUI(
                accountRegion: credentials.region.viRegion,
                channelUuid: credentials.channelUuid,
                token: credentials.token,
                clientId: credentials.clientId
            )
        else {
            throw PigeonError(
                code: "INITIALIZATION_FAILED",
                message: "Failed to initialize VIKitChatUI with provided credentials",
                details: nil
            )
        }

        self.viKitChatUI = viKitChatUI
    }

    func applyCustomization(customization: KitChatCustomization) throws {
        var kitCustomization = VIKitChatUICustomization()
        if let colorScheme = customization.colorScheme {
            kitCustomization.colorScheme = colorScheme.viColorScheme
        }
        if let customizableStrings = customization.customizableStringsIos {
            kitCustomization.strings = customizableStrings.viCustomizableStrings
        }
        if let customizableIcons = customization.customizableIconsIos {
            kitCustomization.icons = customizableIcons.viCustomizableIcons
        }
        self.kitChatCustomization = kitCustomization
    }

    func openChat() throws {
        guard let viKitChatUI = self.viKitChatUI else {
            throw PigeonError(code: "NOT_INITIALIZED", message: "KitChatUI is not initialized", details: nil)
        }

        let rootViewController = try getRootViewController()
        let navigationController = try getNavigationController(from: rootViewController)

        guard let kitChatViewController = VIKitChatViewController(
            id: viKitChatUI.id,
            customization: kitChatCustomization
        )
        else {
            throw PigeonError(
                code: "MISSING_KIT_CHAT_VIEW_CONTROLLER",
                message: "Unable to create chat view controller",
                details: nil
            )
        }

        kitChatViewController.delegate = self
        navigationController.pushViewController(kitChatViewController, animated: true)
    }

    func isChatVisible() throws -> Bool {
        Self.isChatVisible()
    }

    func setClientData(data: KitChatClientData, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let viKitChatUI = self.viKitChatUI else {
            completion(.failure(PigeonError(code: "NOT_INITIALIZED", message: "KitChatUI is not initialized", details: nil)))
            return
        }

        let clientData = VIClientData(
            displayName: data.displayName,
            phone: data.phone,
            avatarUrl: data.avatarUrl,
            email: data.email,
            language: data.language
        )
        viKitChatUI.setClientData(clientData) { error in
            if let error {
                let code: String
                switch error {
                case .emptyData, .invalidEmail:
                    code = "ILLEGAL_ARGUMENT"
                case .networkIssues:
                    code = "CONNECTION_REQUIRED"
                case .timeout:
                    code = "TIMEOUT"
                case .internalError:
                    code = "INTERNAL"
                @unknown default:
                    code = "UNKNOWN"
                }
                completion(.failure(PigeonError(
                    code: code,
                    message: "Failed to set client data: \(error)",
                    details: nil
                )))
            } else {
                completion(.success(()))
            }
        }
    }

    func registerPushToken(token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let viKitChatUI = self.viKitChatUI else {
            completion(.failure(PigeonError(code: "NOT_INITIALIZED", message: "KitChatUI is not initialized", details: nil)))
            return
        }

        guard let pushTokenData = Data(hex: token) else {
            completion(.failure(PigeonError(
                code: "ILLEGAL_ARGUMENT",
                message: "Invalid push token",
                details: nil
            )))
            return
        }
        viKitChatUI.registerPushToken(pushTokenData, isDevelopment: isDevelopmentPushToken) { error in
            if let error {
                let code: String
                switch error {
                case .emptyPushToken:
                    code = "ILLEGAL_ARGUMENT"
                case .networkIssues:
                    code = "CONNECTION_REQUIRED"
                case .timeout:
                    code = "TIMEOUT"
                case .internalError:
                    code = "INTERNAL"
                @unknown default:
                    code = "UNKNOWN"
                }
                completion(.failure(PigeonError(
                    code: code,
                    message: "Failed to register push token: \(error)",
                    details: nil
                )))
            } else {
                completion(.success(()))
            }
        }
    }

    func unregisterPushToken(token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let viKitChatUI = self.viKitChatUI else {
            completion(.failure(PigeonError(code: "NOT_INITIALIZED", message: "KitChatUI is not initialized", details: nil)))
            return
        }
        guard let pushTokenData = Data(hex: token) else {
            completion(.failure(PigeonError(
                code: "ILLEGAL_ARGUMENT",
                message: "Invalid push token",
                details: nil
            )))
            return
        }
        viKitChatUI.unregisterPushToken(pushTokenData, isDevelopment: isDevelopmentPushToken) { error in
            if let error {
                let code: String
                switch error {
                case .emptyPushToken:
                    code = "ILLEGAL_ARGUMENT"
                case .networkIssues:
                    code = "CONNECTION_REQUIRED"
                case .timeout:
                    code = "TIMEOUT"
                case .internalError:
                    code = "INTERNAL"
                @unknown default:
                    code = "UNKNOWN"
                }
                completion(.failure(PigeonError(
                    code: code,
                    message: "Failed to unregister push token: \(error)",
                    details: nil
                )))
            } else {
                completion(.success(()))
            }
        }
    }

    func handlePush(payload: [String: String], completion: @escaping (Result<Void, Error>) -> Void) {
        // Kept for API compatibility with Android implementation
        completion(.success(()))
    }

    public func kitChatViewController(
        _ kitChatViewController: VIKitChatViewController,
        didFailToAuthorizeWithError error: VIAuthorizationError
    ) {
        print("VoximplantKitChat authorization error: \(error)")

        let authError = error.kitChatAuthorizationError
        DispatchQueue.main.async {
            guard let flutterApi = self.flutterApi else {
                print("VoximplantKitChat Flutter API is not set up; authorization error was not forwarded")
                return
            }

            flutterApi.onAuthorizationError(error: authError) { result in
                switch result {
                case .success:
                    print("VoximplantKitChat forwarded authorization error to Flutter: \(authError)")
                case .failure(let error):
                    print("VoximplantKitChat failed to send auth error to Flutter: \(error)")
                }
            }
        }
    }

    private func getRootViewController() throws -> UIViewController {
        guard let rootViewController = UIApplication.shared.firstWindow?.rootViewController else {
            throw PigeonError(
                code: "MISSING_VIEW_CONTROLLER",
                message: "Unable to find root view controller",
                details: nil
            )
        }
        return rootViewController
    }

    private func getNavigationController(from rootViewController: UIViewController) throws -> UINavigationController {
        guard
            let navigationController = (rootViewController as? UINavigationController)
                ?? rootViewController.navigationController
        else {
            throw PigeonError(
                code: "MISSING_VIEW_CONTROLLER",
                message: "Navigation controller is required to open chat",
                details: nil
            )
        }
        return navigationController
    }
}

private extension KitChatRegion {
    var viRegion: VIRegion {
        switch self {
        case .ru:
            return .ru
        case .ru2:
            return .ru2
        case .eu:
            return .eu
        case .us:
            return .us
        case .br:
            return .br
        case .kz:
            return .kz
        }
    }
}

private extension VIAuthorizationError {
    var kitChatAuthorizationError: KitChatAuthorizationError {
        switch self {
        case .invalidChannelUuid: .invalidChannelUuid
        case .invalidToken: .invalidToken
        case .invalidClientId: .invalidClientId
        @unknown default: .unknown
        }
    }
}

private extension Data {
    init?(hex: String) {
        guard hex.count % 2 == 0 else {
            return nil
        }
        let bytes = stride(from: 0, to: hex.count, by: 2).compactMap {
            UInt8(hex[hex.index(hex.startIndex, offsetBy: $0)..<hex.index(hex.startIndex, offsetBy: $0 + 2)], radix: 16)
        }
        guard bytes.count == hex.count / 2 else {
            return nil
        }
        self.init(bytes)
    }
}

public extension VoximplantKitChatPlugin {
    /// Returns `true` if the KitChat screen is currently visible to the user.
    static func isChatVisible() -> Bool {
        UIApplication.shared.firstWindow?.visibleViewController is VIKitChatViewController
    }
}

private extension UIApplication {
    var firstWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })?
            .windows
            .first(where: \.isKeyWindow)
    }
}

private extension UIWindow {
    var visibleViewController: UIViewController? {
        Self.findVisibleViewController(rootViewController)
    }

    private static func findVisibleViewController(_ controller: UIViewController?) -> UIViewController? {
        guard let controller else { return nil }
        if let presented = controller.presentedViewController {
            return findVisibleViewController(presented)
        }
        if let nav = controller as? UINavigationController {
            return findVisibleViewController(nav.visibleViewController)
        }
        if let tab = controller as? UITabBarController {
            return findVisibleViewController(tab.selectedViewController)
        }
        return controller
    }
}
