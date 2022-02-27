//
//  NFTListVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/26.
//

import UIKit

import SnapKit

final class NFTListVC: UIViewController {

    enum Section {
        case main
    }
    
    var walletAddress: String!
    private var collectionView: UICollectionView!
    private var addressCollectionModels: [AddressCollectionModel] = []
    private var dataSource: UICollectionViewDiffableDataSource<Section, AddressCollectionModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "NFT 목록"
        configureNavigationBar()
        configureCollectionView()
        getAddressCollections()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: 컬렉션뷰 초기화
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AssetsCollectionViewCell.self, forCellWithReuseIdentifier: AssetsCollectionViewCell.reuseID)
    }
    
    private func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayout
    }
    
    // MARK: DiffableDataSource
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AddressCollectionModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, asset) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetsCollectionViewCell.reuseID, for: indexPath) as! AssetsCollectionViewCell
            cell.set(asset: asset)
            return cell
        })
    }
    
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AddressCollectionModel>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(addressCollectionModels)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    // MARK: 네트워킹
    
    private func getAddressCollections() {
        NetworkManager.shared.getCollections(url: Endpoint.collections(assetOwner: walletAddress, limit: 100).url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                self.addressCollectionModels = value
                self.updateData()
            case .failure(let error):
                self.presentDefaultStyleAlertVC(title: "에러", body: error.rawValue, buttonTitle: "확인")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
