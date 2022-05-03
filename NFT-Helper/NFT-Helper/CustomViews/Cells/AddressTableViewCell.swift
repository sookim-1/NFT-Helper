//
//  AddressTableViewCell.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/04.
//

import UIKit

import SnapKit

final class AddressTableViewCell: UITableViewCell {

    static let reuseID = "AddressTableViewCell"
    
    let typeImageView = CustomAssetImageView(frame: .zero)
    let addressLabel = CustomDefaultStyleBodyLabel(textAlignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(list: WalletAddress) {
        addressLabel.text = list.address
        switch list.type {
        case .none:
            typeImageView.image = UIImage(systemName: "person")
        case .kaikas:
            typeImageView.image = UIImage(named: "kaikas")
        case .metamask:
            typeImageView.image = UIImage(named: "metamask")
        }
    }
    
    private func configure() {
        contentView.addSubviews(typeImageView, addressLabel)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let padding: CGFloat = 12
        
        typeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(padding)
            make.height.equalTo(60)
            make.width.equalTo(typeImageView.snp.height)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(typeImageView.snp.right).offset(24)
            make.right.equalToSuperview().offset(-padding)
            make.height.equalTo(40)
        }
    }
}
