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
    
    private var addressCollectionModels: [AddressCollectionModel] = []
    private var filterdAddressCollectionModels: [AddressCollectionModel] = []
    
    private var offset: Int = 0
    private var limit: Int = 10
    private var hasMoreModels = true
    private var isSearching = false
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AddressCollectionModel>!
    
    // MARK: 뷰컨트롤러 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "NFT 목록"
        configureNavigationBar()
        configureSearchController()
        configureCollectionView()
        getAddressCollections(offset: offset, limit: limit)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    // MARK: UIKit
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "이름을 검색하세요"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    // MARK: 컬렉션뷰 초기화
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
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
    
    
    private func updateData(on models: [AddressCollectionModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AddressCollectionModel>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(models)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    // MARK: 네트워킹
    
    private func getAddressCollections(offset: Int, limit: Int) {
        showLoadingView()
        NetworkManager.shared.getCollections(url: Endpoint.collections(assetOwner: walletAddress, offset: offset, limit: limit).url) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            switch result {
            case .success(let value):
                if value.count < 10 { self.hasMoreModels = false }
                self.addressCollectionModels.append(contentsOf: value)
                
                if self.addressCollectionModels.isEmpty {
                    print("자산 모델이 없습니다.")
                    return
                }
                self.updateData(on: value)
            case .failure(let error):
                self.presentDefaultStyleAlertVC(title: "에러", body: error.rawValue, buttonTitle: "확인")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension NFTListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreModels else { return }
            limit += 10
            getAddressCollections(offset: offset, limit: limit)
        }
    }
}

extension NFTListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filterdAddressCollectionModels = addressCollectionModels.filter { $0.name.lowercased().contains(filter.lowercased()) }
        updateData(on: filterdAddressCollectionModels)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: addressCollectionModels)
    }

}
