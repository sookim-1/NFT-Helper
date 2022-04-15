//
//  String+Ext.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/14.
//

import Foundation

extension String {
    
    func truncatedPrefix(_ maxLength: Int, using truncator: String = "...") -> String {
        "\(prefix(maxLength))\(truncator)"
    }
    
}
