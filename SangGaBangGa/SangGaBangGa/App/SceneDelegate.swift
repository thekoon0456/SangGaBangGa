//
//  SceneDelegate.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/10/24.
//

import UIKit

import iamport_ios
import IQKeyboardManagerSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        
        let nav = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: nav)
        appCoordinator?.start()
        window?.rootViewController = nav
        setKeyboard()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

// MARK: - iamport_ios

extension SceneDelegate {
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      if let url = URLContexts.first?.url {
        Iamport.shared.receivedURL(url)
      }
    }
}

// MARK: - IQKeyboardManagerSwift

extension SceneDelegate {
    
    func setKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [CommentViewController.self]
        IQKeyboardManager.shared.disabledToolbarClasses = [CommentViewController.self]
    }
}
