//
//  NFTListVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/26.
//

import UIKit

import SnapKit

final class NFTListVC: UIViewController {

    var walletAddress: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "NFT 목록"
        configureNavigationBar()
        getAddressCollections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: 네트워킹
    
    private func getAddressCollections() {
        NetworkManager.shared.getCollections(url: Endpoint.collections(assetOwner: walletAddress, limit: 100).url) { result in
            switch result {
            case .success(let value):
                print(value)
            case .failure(let error):
                self.presentDefaultStyleAlertVC(title: "에러", body: error.rawValue, buttonTitle: "확인")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
