//
//  CalendarListTableVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/14.
//

import UIKit

class CalendarListTableVC: UITableViewController {
    
    enum Section {
        case main
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, MintMetadata>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MintMetadata>
    
    private lazy var dataSource = makeDataSource()
    private lazy var items: [MintMetadata] = []
    
    private var searchQuery: String? = nil {
        didSet {
            applySnapshot()
        }
    }
    
    private lazy var searchController = makeSearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getList()
        applySnapshot(animatingDifferences: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(didTapNewItemButton))
        navigationItem.rightBarButtonItem?.accessibilityLabel = "일정 추가"
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(_:)), name: NSNotification.Name("didRecieveNotification"), object: nil)
    }
    
    func configureTableView() {
        tableView.register(CalendarListTableViewCell.self, forCellReuseIdentifier: CalendarListTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    func getList() {
        PersistenceManager.retrieveCalendarItem { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.items = list
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.presentDefaultStyleAlertVC(title: "에러", body: error.localizedDescription, buttonTitle: "확인")
            }
        }
    }
    
    // MARK: 새로운 VC 
    @objc func didTapNewItemButton() {
        let destVC = NewMintItemVC(mintdata: nil)
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
    @objc func didRecieveNotification(_ notification: Notification) {
        guard let receiveData = notification.userInfo else { return }
        
        guard let metadata: MintMetadata = receiveData["metadata"] as? MintMetadata else { return }
        guard let isEdit: Bool = receiveData["isEdit"] as? Bool else { return }
        guard let indexNum: Int = receiveData["indexPath"] as? Int else { return }
        print("Notfication 데이터: \(metadata)")
        
        print(indexNum)
        if isEdit {
            self.items[indexNum] = metadata
            PersistenceManager.updateWithCalendarItem(calendarItem: metadata, actionType: .edit) { error in
                print(error)
            }
        } else {
            self.items.append(metadata)
            PersistenceManager.updateWithCalendarItem(calendarItem: metadata, actionType: .add) { error in
                print(error)
            }
        }
        self.applySnapshot()
    }

}

extension CalendarListTableVC {
    func applySnapshot(animatingDifferences: Bool = true) {
        var items: [MintMetadata] = self.items
        
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            items = items.filter { item in
                return item.name.lowercased().contains(searchQuery.lowercased())
            }
        }
        
        items = items.sorted { one, two in
            return one.mintDate < two.mintDate
        }
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarListTableViewCell.reuseIdentifier, for: indexPath) as? CalendarListTableViewCell
            cell?.item = item
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = NewMintItemVC(mintdata: items[indexPath.row])
        destVC.index = indexPath.row
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self = self,
                  let item = self.dataSource.itemIdentifier(for: indexPath)
            else {
                return nil
            }
            
            let deleteAction = UIAction(title: "삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    self.items.removeAll { existingItem in
                        PersistenceManager.updateWithCalendarItem(calendarItem: existingItem, actionType: .remove) { error in
                            print(error)
                        }
                        return existingItem == item
                    }
                    
                    self.applySnapshot()
                }
            
            return UIMenu(title: item.name.truncatedPrefix(12), image: nil, children: [deleteAction])
        }
        
        return configuration
    }
}

// MARK: 검색

extension CalendarListTableVC: UISearchResultsUpdating {
    
    func makeSearchController() -> UISearchController {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "검색하기"
        
        return controller
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchQuery = searchController.searchBar.text
    }
    
}
