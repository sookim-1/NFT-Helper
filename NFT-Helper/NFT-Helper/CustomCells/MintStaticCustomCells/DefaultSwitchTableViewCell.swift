//
//  DefaultSwitchTableViewCell.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/14.
//

import UIKit

import SnapKit

class DefaultSwitchTableViewCell: UITableViewCell {

    lazy var label: CustomDefaultStyleTitleLabel = CustomDefaultStyleTitleLabel(textAlignment: .left, fontSize: 16)
    
    lazy var isWhiteListSwitch = UISwitch()
    
    static let reuseIdentifier = String(describing: DefaultSwitchTableViewCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        selectionStyle = .none
        contentView.addSubviews(label, isWhiteListSwitch)
    }
    
    func setUpLayout() {
        label.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(isWhiteListSwitch.snp.left)
        }
        
        isWhiteListSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-20)
        }
    }
}
