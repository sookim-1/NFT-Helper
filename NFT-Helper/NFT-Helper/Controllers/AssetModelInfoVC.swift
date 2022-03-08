//
//  AssetModelInfoVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/03/08.
//

import UIKit

import SnapKit

final class AssetModelInfoVC: UIViewController {

    private let headerView = UIView()
    private let itemViewOne = UIView()
    private let itemViewTwo = UIView()
    private var itemViews: [UIView] = []
    
    var assetModelName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        setUpLayout()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        
        title = assetModelName
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    private func setUpLayout() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            
            itemView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(padding)
                make.trailing.equalToSuperview().offset(-padding)
            }
        }
        
        headerView.backgroundColor = .systemYellow
        itemViewOne.backgroundColor = .systemGreen
        itemViewTwo.backgroundColor = .systemPurple
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(180)
        }
        
        itemViewOne.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(padding)
            make.height.equalTo(itemHeight)
        }
        
        itemViewTwo.snp.makeConstraints { make in
            make.top.equalTo(itemViewOne.snp.bottom).offset(padding)
            make.height.equalTo(itemHeight)
        }
    }
}
