import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Public property
    
    var window: UIWindow?
    
    // MARK: Private property
    
    private let isOnboardingShown = UserDefaultsBacked<Bool>(key: "isOnboardingShown", defaultValue: false)
    
    // MARK: Public method
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let rootViewController: UIViewController
        if isOnboardingShown.wrappedValue {
            rootViewController = TabBarViewController()
            rootViewController.awakeFromNib()
        } else {
            rootViewController = OnboardingPageController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal, options: nil
            )
        }
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}

