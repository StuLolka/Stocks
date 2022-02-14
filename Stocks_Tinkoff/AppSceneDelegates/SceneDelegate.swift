import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        guard let windowScene = (scene as? UIWindowScene) else { return }
    
        let mainScreen = Builder.shared.getStocksScreen()
        let navigationController = UINavigationController(rootViewController: mainScreen)
        window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }


}

