//
//  ItemInfoVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/04.
//

import UIKit

import SnapKit

class ItemInfoVC: UIViewController {
    
    let stackView = UIStackView()
    let itemInfoViewOne = ItemInfoView()
    let actionButton = CustomDefaultStyleButton()
    
    var addressCollectionModel: AddressCollectionModel!

    init(addressCollectionModel: AddressCollectionModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.addressCollectionModel = addressCollectionModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackgroundView()
        configureActionButton()
        layoutUI()
        configureStackView()
    }
    
    private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }

    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(itemInfoViewOne)
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func actionButtonTapped() {
        
    }
    
    private func layoutUI() {
        view.addSubviews(stackView, actionButton)
        
        let padding: CGFloat = 20
        
        stackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
            make.height.equalTo(50)
        }
        
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.right.bottom.equalToSuperview().offset(-padding)
            make.left.equalToSuperview().offset(padding)
        }
    }

}
