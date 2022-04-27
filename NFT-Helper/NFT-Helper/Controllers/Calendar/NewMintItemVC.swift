//
//  NewMintItemVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/14.
//

import UIKit

import SnapKit

class NewMintItemVC: UIViewController {

    private let tableView = UITableView()
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    var mintdata: MintMetadata = MintMetadata(name: "", chainName: .none, price: 0, isWhiteList: false, mintDate: Date(), mintTime: Date())
    var isEditItem: Bool = false
    var index: Int = 1
    
    init(mintdata: MintMetadata?) {
        super.init(nibName: nil, bundle: nil)

        if let mintdata = mintdata {
            self.mintdata = mintdata
            title = "일정 수정"
            self.isEditItem = true
            print("초기화 \(self.mintdata), index: \(index)")
        } else {
            title = "일정 추가"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTableView()
        setUpLayout()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTabDone))
        navigationItem.rightBarButtonItem = doneButton
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(DefaultTextFieldTableViewCell.self, forCellReuseIdentifier: DefaultTextFieldTableViewCell.reuseIdentifier)
        tableView.register(ChainCategoryTableViewCell.self, forCellReuseIdentifier: ChainCategoryTableViewCell.reuseIdentifier)
        tableView.register(DefaultSwitchTableViewCell.self, forCellReuseIdentifier: DefaultSwitchTableViewCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(DefaultTimeTableViewCell.self, forCellReuseIdentifier: DefaultTimeTableViewCell.reuseIdentifier)
    }
    
    func setUpLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func didTabDone() {
        if mintdata.name != "" {
            
            print("Done: \(mintdata)")
            if isEditItem {
                let data = ["metadata" : mintdata, "isEdit" : true, "indexPath" : index] as [String : Any]
                
                NotificationCenter.default.post(name: Notification.Name("didRecieveNotification"), object: nil, userInfo: data)
            } else {
                let data = ["metadata" : mintdata, "isEdit" : false, "indexPath" : index] as [String : Any]
                
                NotificationCenter.default.post(name: Notification.Name("didRecieveNotification"), object: nil, userInfo: data)
            }
            dismiss(animated: true)
        } else {
            self.presentDefaultStyleAlertVC(title: "이름 입력", body: "이름을 입력해주세요", buttonTitle: "확인")
        }
    }
    
    @objc func dismissVC() {
        
        dismiss(animated: true)
    }
}

extension NewMintItemVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTextFieldTableViewCell.reuseIdentifier, for: indexPath) as? DefaultTextFieldTableViewCell
            else { return UITableViewCell() }
            
            if mintdata.name != "" {
                cell.textField.text = mintdata.name
            }
            cell.setUpText(labelText: "프로젝트명", placeholder: "이름을 입력해주세요")
            cell.textField.addTarget(self, action: #selector(self.didChangedNameTextField(_:)), for: .editingChanged)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChainCategoryTableViewCell.reuseIdentifier, for: indexPath) as? ChainCategoryTableViewCell
            else { return UITableViewCell() }
            
            cell.delegate = self
            
            print(mintdata.chainName)
            if isEditItem {
                switch mintdata.chainName {
                case .eth:
                    cell.ethButton.configuration?.baseBackgroundColor = .systemPurple.withAlphaComponent(0.7)
                case .klaytn:
                    cell.klayButton.configuration?.baseBackgroundColor = .systemPurple.withAlphaComponent(0.7)
                case .none:
                    print("none")
                }
            }
        
            mintdata.chainName = cell.category
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTextFieldTableViewCell.reuseIdentifier, for: indexPath) as? DefaultTextFieldTableViewCell
            else { return UITableViewCell() }
            
            if isEditItem {
                cell.textField.text = "\(mintdata.price)"
            }
            cell.setUpText(labelText: "가격", placeholder: "가격을 입력해주세요")
            cell.textField.addTarget(self, action: #selector(self.didChangedPriceTextField(_:)), for: .editingChanged)
            cell.textField.keyboardType = .numbersAndPunctuation
            
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultSwitchTableViewCell.reuseIdentifier, for: indexPath) as? DefaultSwitchTableViewCell
            else { return UITableViewCell() }
            
            if isEditItem {
                cell.isWhiteListSwitch.isOn = mintdata.isWhiteList
            }
            cell.label.text = "화이트리스트 여부"
            cell.isWhiteListSwitch.addTarget(self, action: #selector(self.didChangedSwitch(_:)), for: .valueChanged)
            
            return cell
        case 4:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.text = "민팅 일정"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            cell.textLabel?.textAlignment = .left
            cell.detailTextLabel?.text = dateFormatter.string(from: mintdata.mintDate)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTimeTableViewCell.reuseIdentifier, for: indexPath) as? DefaultTimeTableViewCell
            else { return UITableViewCell() }
            
            cell.label.text = "민팅 시간"
            cell.timePicker.date = mintdata.mintTime
            cell.timePicker.timeZone = NSTimeZone.local
            
            cell.timePicker.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)

            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            let pickerController = CalendarVC(baseDate: mintdata.mintDate, selectedDateChanged: { [weak self] date in
                    guard let self = self else { return }
            
                    self.mintdata.mintDate = date
                    self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .fade)
                })
            
            present(pickerController, animated: true, completion: nil)
        }
        
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 1:
//            return 500
//        default:
//            return 160
//        }
//    }
}

extension NewMintItemVC: ChainCategoryDelegate {
    
    @objc func didChangedNameTextField(_ textField: UITextField) {
        mintdata.name = textField.text!
    }
    
    func didTapEthbtn() {
        mintdata.chainName = .eth
        print(mintdata.chainName)
    }
    
    func didTapKlaybtn() {
        mintdata.chainName = .klaytn
        print(mintdata.chainName)
    }
    
    @objc func didChangedPriceTextField(_ textField: UITextField) {
        guard let doublePrice = Double(textField.text!) else {
            self.presentDefaultStyleAlertVC(title: "입력 에러", body: "숫자만 입력해주세요", buttonTitle: "확인")
            textField.text = ""
            
            return
        }
        print("doublePrice: \(doublePrice)")
        mintdata.price = doublePrice
        
    }
    
    @objc func didChangedSwitch(_ isWhiteList: UISwitch) {
        print("isWhiteList: \(isWhiteList.isOn)")
        mintdata.isWhiteList = isWhiteList.isOn
    }
    
    @objc func onDidChangeDate(sender: UIDatePicker) {
//        let dateFormatter: DateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "a hh:mm"
//        let selectedDate: String = dateFormatter.string(from: sender.date)
        self.mintdata.mintTime = sender.date
    }
}
