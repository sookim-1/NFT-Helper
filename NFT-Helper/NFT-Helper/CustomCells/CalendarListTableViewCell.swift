//
//  CalendarListTableViewCell.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/14.
//

import UIKit

import SnapKit

class CalendarListTableViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityTraits = .button
        label.isAccessibilityElement = true
        
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        
        return label
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    var item: MintMetadata? {
        didSet {
            guard let item = item else {
                return
            }
            
            let subtitleText = dateFormatter.string(from: item.mintDate)
            
            titleLabel.text = item.name
            subtitleLabel.text = subtitleText
            
            titleLabel.accessibilityLabel = "\(item.name)\n\(subtitleText)"
        }
    }
    
    static let reuseIdentifier = String(describing: CalendarListTableViewCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubviews(titleLabel, subtitleLabel)
        
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(4)
            make.top.equalTo(contentView.snp.top).offset(10)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        layoutSubviews()
    }
}
