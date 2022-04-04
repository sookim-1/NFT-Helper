//
//  AssetItemInfoVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/04.
//

import UIKit

protocol AssetItemInfoVCDelegate: AnyObject {
    func didTapLink(for assetModel: AddressCollectionModel)
}

class AssetNameItemInfoVC: ItemInfoVC {

    weak var delegate: AssetItemInfoVCDelegate!
    
    init(addressCollectionModel: AddressCollectionModel, delegate: AssetItemInfoVCDelegate) {
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
        itemInfoViewOne.set(itemInfoType: .name, subLabelText: "\(addressCollectionModel.name)")
        actionButton.set(backgroundColor: .systemBlue.withAlphaComponent(0.7), title: "공식링크")
    }
    
    override func actionButtonTapped() {
        delegate.didTapLink(for: addressCollectionModel)
    }
    

}
