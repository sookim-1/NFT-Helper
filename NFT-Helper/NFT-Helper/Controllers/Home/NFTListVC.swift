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
    
    var walletAddress: String?
    var slugArray: [String] = []
    var slugArrayCount: Int = 0
    
    private var addressCollectionModels: [AddressCollectionModel] = []
    private var filterdAddressCollectionModels: [AddressCollectionModel] = []
    private var isSearching = false
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AddressCollectionModel>!
    
    // MARK: 뷰컨트롤러 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        addressCollectionModels = []
        filterdAddressCollectionModels = []
        slugArray = []
        configureWalletAddress()
        scrappingWalletAddress()
        kaikasGetAddressCollection(slugArray: slugArray) { count in
            print("끝난 숫자\(count)")
            
            if count == self.slugArrayCount {
                print("@붙인 문자열 : \(self.stringConvert())")
                self.callURL(text: self.stringConvert()) { result in
                    switch result {
                    case .success(let callToData):
                        var result = callToData.message.result.translatedText.components(separatedBy: "@")
                        result.removeLast()
                        print("결과배열:\(result)")
                        print("count:\(count)")
                        for index in 0..<count {
                            self.addressCollectionModels[index].name = result[index]
                        }
                        self.updateData(on: self.addressCollectionModels)
                        self.dismissLoadingView()
                    case .failure(let error):
                        print(error.rawValue)
                        self.dismissLoadingView()
                    }
                }
            }
        }

        //callURL(text: str)
        
        
        collectionView.reloadData()
    }
    
    private func configureWalletAddress() {
        if UserDefaults.walletAddress != "" {
            walletAddress = UserDefaults.walletAddress
        } else {
            walletAddress = nil
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
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AssetsCollectionViewCell.self, forCellWithReuseIdentifier: AssetsCollectionViewCell.reuseID)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
    
    // MARK: 메타마스크 지원 API
//    private func getAddressCollections(offset: Int, limit: Int) {
//        showLoadingView()
//        NetworkManager.shared.getCollections(url: Endpoint.collections(assetOwner: walletAddress, offset: offset, limit: limit).url) { [weak self] result in
//            guard let self = self else { return }
//
//            self.dismissLoadingView()
//            switch result {
//            case .success(let value):
//                if value.count < 10 { self.hasMoreModels = false }
//                self.addressCollectionModels.append(contentsOf: value)
//
//                if self.addressCollectionModels.isEmpty {
//                    print("자산 모델이 없습니다.")
//                    return
//                }
//                self.updateData(on: value)
//            case .failure(let error):
//                self.presentDefaultStyleAlertVC(title: "에러", body: error.rawValue, buttonTitle: "확인")
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
//    }
    
    // MARK: 카이카스 지원 API
    private func kaikasGetAddressCollection(slugArray: [String], completion: @escaping (Int) -> Void) {
        showLoadingView()
        
        if slugArray.isEmpty && !UserDefaults.isEmptyWalletAddress! {
            self.showEmptyStateView(with: "NFT작품이 없어요😱", in: self.view)
            self.dismissLoadingView()
            
            return
        }
        
        let emptyView = view.viewWithTag(199)
        emptyView?.removeFromSuperview()
        
        let setResult: Set<String> = Set(slugArray)
        let arrayResult = Array(setResult)
        slugArrayCount = arrayResult.count
        
        print("\(arrayResult)")
        //let semaphore = DispatchSemaphore(value: 1)
        var countThread = 0
        
        for i in 0..<arrayResult.count {
            DispatchQueue(label: "SerialQueue").sync {
                //semaphore.wait()
                
                NetworkManager.shared.addCollection(url: Endpoint.kaikasCollection(slug: arrayResult[i]).url) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let value):
                        let addressCollection = AddressCollectionModel(name: value.collection.name, stats: value.collection.stats, externalURL: value.collection.externalURL, imageURL: value.collection.imageURL, slug: arrayResult[i])
                        self.addressCollectionModels.append(addressCollection)
                        print("이름 :\(addressCollection.name)")
                        self.updateData(on: self.addressCollectionModels)
                        
                        countThread += 1
                        print("인덱스: \(i)")
                        
                        print(countThread)
                        print("배열 개수: \(arrayResult.count)")
                        completion(countThread)
                    case .failure(let error):
                        self.presentDefaultStyleAlertVC(title: "에러", body: error.rawValue, buttonTitle: "확인")
                    }
                }
                
                //semaphore.signal()
                
            }
        }
        
        
        
    }
    
    func stringConvert() -> String {
        var str = ""
        
        for i in 0..<addressCollectionModels.count {
            addressCollectionModels[i].name = addressCollectionModels[i].name.replacingOccurrences(of: " ", with: "")
        }
        
        for i in 0..<addressCollectionModels.count {
            str.append(addressCollectionModels[i].name)
            str.append("@")
        }
        
        return str
    }
    
    
    // MARK: Kaikas 지갑
    private func scrappingWalletAddress() {
        
        guard let walletAddress = walletAddress else {
            self.showEmptyStateView(with: "지갑주소를 등록해주세요😱", in: self.view)
            self.dismissLoadingView()
            UserDefaults.isEmptyWalletAddress = true
            
            return
        }
        
        let emptyView = view.viewWithTag(99)
        emptyView?.removeFromSuperview()
        
        guard let url = URL(string: "https://opensea.io/\(walletAddress)") else { return }
        
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
           print("크롤링 에러 : \(error)")
       }
    }
    
    
    func callURL(text: String, completion: @escaping (Result<PaPagoModel, NetWorkErrorMessage>) -> Void) {
        let param = "source=en&target=ko&text=\(text)"
        let paramData = param.data(using: .utf8)
    
        var request = URLRequest(url: URL(string: PaPagoAPIKey.papagoURLString)!)
        request.httpMethod = "POST"
        request.addValue(PaPagoAPIKey.ClientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(PaPagoAPIKey.ClientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        request.httpBody = paramData
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
        URLSession.request(endpoint: request, completion: completion)
    }
}

extension NFTListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
//            guard hasMoreModels else { return }
//            limit += 10
//            getAddressCollections(offset: offset, limit: limit)
            print("페이지넘김")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filterdAddressCollectionModels : addressCollectionModels
        let addressCollectionModel = activeArray[indexPath.item]
        
        let destVC = AssetModelInfoVC()
        destVC.assetModelName = addressCollectionModel
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


// MARK: - Post
struct PaPagoModel: Codable {
    let message: Message
}

// MARK: - Message
struct Message: Codable {
    let result: TranslateResult
}

// MARK: - Result
struct TranslateResult: Codable {
    let translatedText: String
}
