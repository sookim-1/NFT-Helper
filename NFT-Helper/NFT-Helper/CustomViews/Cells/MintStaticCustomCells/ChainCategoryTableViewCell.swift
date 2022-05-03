//
//  ChainCategoryTableViewCell.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/14.
//

import UIKit

import SnapKit

protocol ChainCategoryDelegate: AnyObject {
    func didTapEthbtn()
    func didTapKlaybtn()
}

class ChainCategoryTableViewCell: UITableViewCell {

    lazy var label: CustomDefaultStyleTitleLabel = CustomDefaultStyleTitleLabel(textAlignment: .left, fontSize: 16)
    
    lazy var btnStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ethButton, klayButton])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        return stackView
    }()

    lazy var ethButton: UIButton = {
        let btn = UIButton(frame: .zero)
        
        btn.configuration = .borderedTinted()
        btn.configuration?.baseBackgroundColor = .systemCyan
        btn.configuration?.cornerStyle = .medium
        btn.configuration?.image = UIImage(named: "eth_icon")
        btn.configuration?.imagePlacement = .all
        
        return btn
    }()
    
    lazy var klayButton: UIButton = {
        let btn = UIButton(frame: .zero)
        
        btn.configuration = .borderedTinted()
        btn.configuration?.baseBackgroundColor = .systemCyan
        btn.configuration?.cornerStyle = .medium
        
        btn.configuration?.image = UIImage(named: "klay_icon")
        btn.configuration?.imagePlacement = .all
        
        return btn
    }()
    
    static let reuseIdentifier = String(describing: ChainCategoryTableViewCell.self)
    var category: ChainList = .none
    weak var delegate: ChainCategoryDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        label.text = "체인 종류"
        selectionStyle = .none
        
        contentView.addSubviews(label, btnStackView)
        ethButton.addTarget(self, action: #selector(didTapEthBtn), for: .touchUpInside)
        klayButton.addTarget(self, action: #selector(didTapKlayBtn), for: .touchUpInside)
    }
    
    func setUpLayout() {
        ethButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.left.bottom.equalToSuperview()
        }
        klayButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.right.bottom.equalToSuperview()
        }
        
        btnStackView.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
            make.width.equalTo(120)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.centerY.equalTo(contentView)
            make.right.equalTo(btnStackView.snp.left)
        }
    }
    
    @objc func didTapEthBtn() {
        ethButton.configuration?.baseBackgroundColor = .systemPurple.withAlphaComponent(0.7)
        klayButton.configuration?.baseBackgroundColor = .systemCyan
        
        delegate?.didTapEthbtn()
    }
    
    @objc func didTapKlayBtn() {
        klayButton.configuration?.baseBackgroundColor = .systemPurple.withAlphaComponent(0.7)
        ethButton.configuration?.baseBackgroundColor = .systemCyan
        
        delegate?.didTapKlaybtn()
    }
    
}
