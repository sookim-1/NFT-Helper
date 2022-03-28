//
//  NFTListVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/26.
//

import UIKit

import SnapKit
import SwiftSoup

final class NFTListVC: UIViewController {

    enum Section {
        case main
    }
    
    var walletAddress: String!
    var slugArray: [String] = []
    
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
//        configureWalletAddress()


        
//        getAddressCollections(offset: offset, limit: limit)
        
        scrappingWalletAddress()
        kaikasGetAddressCollection(slugArray: slugArray)
        
        configureNavigationBar()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configureWalletAddress() {
        if UserDefaults.metamaskAddress != "" {
            walletAddress = UserDefaults.metamaskAddress
        }
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
    
    private func kaikasGetAddressCollection(slugArray: [String]) {
        showLoadingView()
        let setResult: Set<String> = Set(slugArray)
        let arrayResult = Array(setResult)
        print("\(arrayResult)")
        
        for i in arrayResult {
            NetworkManager.shared.addCollection(url: Endpoint.kaikasCollection(slug: i).url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case . success(let value):
                    let addressCollection = AddressCollectionModel(name: value.collection.name, externalURL: value.collection.externalURL, imageURL: value.collection.imageURL, slug: i)
                    self.addressCollectionModels.append(addressCollection)
                    self.updateData(on: self.addressCollectionModels)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        dismissLoadingView()
    }
    
    
    // MARK: Kaikas 지갑
    private func scrappingWalletAddress() {
        self.walletAddress = "0xd3F470C90461509c664f777179e2daF8ee176877"
        guard let url = URL(string: "https://opensea.io/" + self.walletAddress) else { return }
        
        do {
           let html = try String(contentsOf: url, encoding: .utf8)
           let doc: Document = try SwiftSoup.parse(html)
        
           let elements: Elements = try doc.getElementsByClass("Blockreact__Block-sc-1xf18x6-0 hjbqQx").select("a")

           for element in elements.array() {
               let link = try element.attr("href")
               let startIdx: String.Index = link.index(link.startIndex, offsetBy: 12)
               let result = String(link[startIdx...])
               slugArray.append(result)
           }
       } catch let error {
           print("에러 : \(error)")
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filterdAddressCollectionModels : addressCollectionModels
        let addressCollectionModel = activeArray[indexPath.item]
        
        let destVC = AssetModelInfoVC()
        destVC.assetModelName = addressCollectionModel.name
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
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
