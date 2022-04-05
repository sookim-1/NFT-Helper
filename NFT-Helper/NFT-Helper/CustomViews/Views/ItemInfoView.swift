//
//  ItemInfoView.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/04.
//

import UIKit

import SnapKit

enum ItemInfoType {
    case floorPrice, name
}

class ItemInfoView: UIView {

    let symbolImageView = UIImageView()
    let titleLabel = CustomDefaultStyleTitleLabel(textAlignment: .left, fontSize: 14)
    let subLabel = CustomDefaultStyleTitleLabel(textAlignment: .center, fontSize: 14)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(symbolImageView, titleLabel, subLabel)
        
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label
        
        symbolImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(symbolImageView.snp.centerY)
            make.right.equalToSuperview()
            make.height.equalTo(18)
            make.left.equalTo(symbolImageView.snp.right).offset(12)
        }
        
        subLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(18)
            make.top.equalTo(symbolImageView.snp.bottom).offset(4)
        }
    }
    
    func set(itemInfoType: ItemInfoType, subLabelText: String) {
        switch itemInfoType {
        case .floorPrice:
            symbolImageView.image = UIImage(named: "ETH")
            titleLabel.text = "최저가"
        case .name:
            symbolImageView.image = UIImage(systemName: "person.fill")
            titleLabel.text = "NFT명"
        }
        
        subLabel.text = subLabelText
    }
}
