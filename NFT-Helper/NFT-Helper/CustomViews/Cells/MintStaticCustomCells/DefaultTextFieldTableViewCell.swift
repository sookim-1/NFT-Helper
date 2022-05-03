//
//  ProjectNameTableViewCell.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/14.
//

import UIKit

class DefaultTextFieldTableViewCell: UITableViewCell {

    lazy var label: CustomDefaultStyleTitleLabel = CustomDefaultStyleTitleLabel(textAlignment: .left, fontSize: 16)
    lazy var textField = UITextField()
    
    static let reuseIdentifier = String(describing: DefaultTextFieldTableViewCell.self)
    
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
        contentView.addSubviews(label, textField)
    }
    
    func setUpLayout() {
        label.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.centerY.equalTo(contentView)
        }
        
        textField.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
            make.width.equalTo(180)
        }
    }
    
    func setUpText(labelText: String, placeholder: String) {
        label.text = labelText
        textField.placeholder = placeholder
    }
 
}
