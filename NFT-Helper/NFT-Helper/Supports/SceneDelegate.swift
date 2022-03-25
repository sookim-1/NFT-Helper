//
//  SceneDelegate.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        let firstLaunch = FirstLaunch(userDefaults: .standard, key: "firstLaunchKey")
        if firstLaunch.isFirstLaunch {
            window?.rootViewController = OnboardingVC()
        } else {
            window?.rootViewController = createTabbarController()
        }
        
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        
        configureNavigationBar()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // MARK: - 탭바 설정
    
    private func createTabbarSubVC(viewcotroller: UIViewController, tabBarStyle: UITabBarItem.SystemItem, tag: Int) -> UINavigationController {
        let vc = viewcotroller
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: tabBarStyle, tag: tag)
        
        return UINavigationController(rootViewController: vc)
    }

    func createTabbarController() -> UITabBarController {
        let tabbarController = UITabBarController()
        UITabBar.appearance().tintColor = .systemGreen
        UITabBar.appearance().backgroundColor = .systemGray6
        tabbarController.viewControllers = [createTabbarSubVC(viewcotroller: NFTListVC(), tabBarStyle: .search, tag: 0),
                                            createTabbarSubVC(viewcotroller: CalendarVC(), tabBarStyle: .bookmarks, tag: 1),
                                            createTabbarSubVC(viewcotroller: CalculatorVC(), tabBarStyle: .featured, tag: 2),
                                            createTabbarSubVC(viewcotroller: SettingVC(), tabBarStyle: .contacts, tag: 3)]
        
        return tabbarController
    }
    
    // MARK: - 네비게이션바 설정
    private func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemGreen
        UINavigationBar.appearance().backgroundColor = .systemGray6
    }

}

