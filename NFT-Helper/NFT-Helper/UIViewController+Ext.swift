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
}
