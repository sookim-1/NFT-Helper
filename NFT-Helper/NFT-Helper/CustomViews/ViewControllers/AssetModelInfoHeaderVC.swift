//
//  AssetModelInfoHeaderView.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/04.
//

import UIKit

import SnapKit

class AssetModelInfoHeaderVC: UIViewController {
    
    let avatarImageView = CustomAssetImageView(frame: .zero)
    
    var assetModel: AddressCollectionModel!
    
    init(assetModel: AddressCollectionModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.assetModel = assetModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubViews()
        layoutUI()
        
        //avatarImageView.downloadImage(from: assetModel.imageURL)
        avatarImageView.image = assetModel.name.textToImage(imgSize: CGSize(width: 60, height: 60))?.imageWithColor(color: getRandomColor())
    }
    
    func addSubViews() {
        view.addSubviews(avatarImageView)
    }

    func layoutUI() {
        avatarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
