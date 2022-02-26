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

    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
