//
//  CustomTabBarController.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/04.
//

import UIKit

struct TabBarSubModel {
    let title: String
    let image: UIImage
    let selectedImage: UIImage
    let tag: Int
}

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //let homeModel = TabBarSubModel(title: "홈", image: UIImage(systemName: "house")!, selectedImage: UIImage(systemName: "house.fill")!, tag: 0)
        let calendarModel = TabBarSubModel(title: "일정", image: UIImage(systemName: "calendar.circle")!, selectedImage: UIImage(systemName: "calendar.circle.fill")!, tag: 0)
        let calculatorModel = TabBarSubModel(title: "계산기", image: UIImage(systemName: "square.grid.3x3")!, selectedImage: UIImage(systemName: "square.grid.3x3.fill")!, tag: 1)
        let settingModel = TabBarSubModel(title: "설정", image: UIImage(systemName: "person")!, selectedImage: UIImage(systemName: "person.fill")!, tag: 2)
        
        viewControllers = [//createTabbarSubVC(viewcotroller: NFTListVC(), tabBarSubModel: homeModel),
                           createTabbarSubVC(viewcotroller: CalendarListTableVC(), tabBarSubModel: calendarModel),
                           createTabbarSubVC(viewcotroller: CalculatorVC(fp: 0), tabBarSubModel: calculatorModel),
                           createTabbarSubVC(viewcotroller: SettingVC(), tabBarSubModel: settingModel)]
        
        configureTabBar()
    }
    
    private func createTabbarSubVC(viewcotroller: UIViewController, tabBarSubModel: TabBarSubModel) -> UINavigationController {
        let vc = viewcotroller
        vc.title = tabBarSubModel.title
        vc.tabBarItem = UITabBarItem(title: tabBarSubModel.title, image: tabBarSubModel.image, selectedImage: tabBarSubModel.selectedImage)
        vc.tabBarItem.tag = tabBarSubModel.tag
        
        return UINavigationController(rootViewController: vc)
    }
    
    // MARK: - 탭바 설정
    private func configureTabBar() {
        UITabBar.appearance().tintColor = .systemGreen
        UITabBar.appearance().backgroundColor = .systemGray6
    }
    
}
