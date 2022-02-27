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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
