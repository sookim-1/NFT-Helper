//
//  SettingVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/03/25.
//

import UIKit

class SettingVC: UIViewController {

    let tableView = UITableView()
    var walletAddressList: [WalletAddress] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAddress()
    }
    
    func configureViewController() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func addButtonTapped() {
        navigationController?.pushViewController(AddressRegisterVC(isFirst: false), animated: true)
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.register(AddressTableViewCell.self, forCellReuseIdentifier: AddressTableViewCell.reuseID)
    }
    
    func getAddress() {
        PersistenceManager.retrieveAddress { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                
                if list.isEmpty {
                    self.presentDefaultStyleAlertVC(title: "빈 목록", body: "주소를 추가해주세요", buttonTitle: "확인")
                } else {
                    self.walletAddressList = list
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let error):
                self.presentDefaultStyleAlertVC(title: "에러", body: error.localizedDescription, buttonTitle: "확인")
            }
        }
    }
    
    
}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletAddressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.reuseID) as! AddressTableViewCell
        let address = walletAddressList[indexPath.row]
        
        cell.set(list: address)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.walletAddress = walletAddressList[indexPath.row].address
        UserDefaults.isEmptyWalletAddress = false
        
        tabBarController?.selectedIndex = 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateWith(addressModel: walletAddressList[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            guard let _ = error else {
                self.walletAddressList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            
            print("삭제불가")
        }
    }
}
