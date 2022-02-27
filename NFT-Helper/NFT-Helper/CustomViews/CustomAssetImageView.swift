//
//  CustomAssetImageView.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/27.
//

import UIKit

final class CustomAssetImageView: UIImageView {

    private let placeholderImage = UIImage(named: "dented_feels1")

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
    }

}
