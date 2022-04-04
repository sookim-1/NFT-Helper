//
//  AssetPriceItemInfoVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/04.
//

import UIKit

protocol AssetPriceItemInfoVCDelegate: AnyObject {
    func didTapPrice(for assetModel: AddressCollectionModel)
}

class AssetPriceItemInfoVC: ItemInfoVC {

    weak var delegate: AssetPriceItemInfoVCDelegate!
    
    init(addressCollectionModel: AddressCollectionModel, delegate: AssetPriceItemInfoVCDelegate) {
        super.init(addressCollectionModel: addressCollectionModel)
        
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .floorPrice, subLabelText: "\(addressCollectionModel.stats["floor_price"]!)")
        actionButton.set(backgroundColor: .systemPink.withAlphaComponent(0.7), title: "원화 가격")
    }
    
    override func actionButtonTapped() {
        delegate.didTapPrice(for: addressCollectionModel)
    }
}
