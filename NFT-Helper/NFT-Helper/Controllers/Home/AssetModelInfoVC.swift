//
//  AssetModelInfoVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/03/08.
//

import UIKit

import SnapKit

final class AssetModelInfoVC: UIViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private let headerView = UIView()
    private let itemViewOne = UIView()
    private let itemViewTwo = UIView()
    private var itemViews: [UIView] = []
    
    var assetModelName: AddressCollectionModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureUIElements(with: assetModelName)
        setUpLayout()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        
        title = assetModelName.name
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(600)
            make.width.equalTo(scrollView.snp.width)
        }
    }

    func configureUIElements(with address: AddressCollectionModel) {
        self.add(childVC: AssetNameItemInfoVC(addressCollectionModel: address, delegate: self), to: self.itemViewOne)
        self.add(childVC: AssetPriceItemInfoVC(addressCollectionModel: address, delegate: self), to: self.itemViewTwo)
        self.add(childVC: AssetModelInfoHeaderVC(assetModel: address), to: self.headerView)
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
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(180)
            make.width.equalTo(headerView.snp.height)
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

extension AssetModelInfoVC: AssetItemInfoVCDelegate {
    func didTapLink(for assetModel: AddressCollectionModel) {
        guard let url = URL(string: assetModel.externalURL!) else {
            presentDefaultStyleAlertVC(title: "잘못된 링크", body: "링크오류", buttonTitle: "확인")
            return
        }
        
        presentSafariVC(with: url)
    }
}

extension AssetModelInfoVC: AssetPriceItemInfoVCDelegate {
    func didTapPrice(for assetModel: AddressCollectionModel) {
        self.navigationController?.pushViewController(CalculatorVC(fp: assetModel.stats["floor_price"]!), animated: true)
    }
}
