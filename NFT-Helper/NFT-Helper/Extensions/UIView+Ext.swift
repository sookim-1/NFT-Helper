//
//  UIView+Ext.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/04.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
    
}
