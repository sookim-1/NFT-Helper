//
//  AssetsCollectionViewCell.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/27.
//

import UIKit

import SnapKit

final class AssetsCollectionViewCell: UICollectionViewCell {
    static let reuseID = "AssetsCollectionViewCell"

    private let assetImageView = CustomAssetImageView(frame: .zero)
    private let assetNameLabel = CustomDefaultStyleTitleLabel(textAlignment: .center, fontSize: 16)

    private let padding: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(asset: AddressCollectionModel) {
        assetNameLabel.text = asset.name
        assetImageView.downloadImage(from: asset.imageURL)
    }

    private func configure() {
        addSubview(assetImageView)
        addSubview(assetNameLabel)
    }
    
    private func setUpLayout() {
        assetImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(padding)
            make.left.equalTo(contentView.snp.left).offset(padding)
            make.right.equalTo(contentView.snp.right).offset(-padding)
            make.height.equalTo(assetImageView.snp.width)
        }
        
        assetNameLabel.snp.makeConstraints { make in
            make.top.equalTo(assetImageView.snp.bottom).offset(12)
            make.left.equalTo(assetImageView.snp.left).offset(padding)
            make.right.equalTo(contentView.snp.right).offset(-padding)
            make.height.equalTo(20)
        }
    }
}
