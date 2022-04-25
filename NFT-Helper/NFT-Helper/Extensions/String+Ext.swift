//
//  String+Ext.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/14.
//

import UIKit

extension String {
    
    func truncatedPrefix(_ maxLength: Int, using truncator: String = "...") -> String {
        "\(prefix(maxLength))\(truncator)"
    }
    
    func textToImage(imgSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(imgSize, false, 0)
        UIColor.clear.set()

        let rect = CGRect(origin: .zero, size: imgSize)
        UIRectFill(CGRect(origin: .zero, size: imgSize))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 10)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
}
