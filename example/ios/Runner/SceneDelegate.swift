import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)

        guard let rootViewController = window?.rootViewController else {
            return
        }

        if rootViewController is UINavigationController {
            return
        }

        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
    }
}
