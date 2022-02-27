//
//  UIViewController+Ext.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/26.
//

import UIKit

import Toast

extension UIViewController {
    func centerToastMessage(text: String) {
        self.view.makeToast(text, point: self.view.center, title: nil, image: nil, completion: nil)
    }
    
    func presentDefaultStyleAlertVC(title: String, body: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = CustomDefaultStyleAlertVC(title: title, body: body, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            
            self.present(alertVC, animated: true)
        }
    }
}
