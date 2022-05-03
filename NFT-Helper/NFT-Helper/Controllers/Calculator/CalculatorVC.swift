//
//  CalculatorVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/03/25.
//

import UIKit

import Alamofire
import Starscream
import ProgressHUD

struct FlagStruct {
    var ethFlag: Bool = false
    var klayFlag: Bool = false

    func allTrue() -> Bool {
        if ethFlag == true && klayFlag == true {
            return true
        }
        return false
    }
}

enum CoinType {
    case eth
    case klay
}

final class CalculatorVC: UIViewController, WebSocketDelegate {

    private var webSocket: WebSocket!

    private let mainView = CalculatorView()

    private var ethPrice: Double = 0
    private var klayPrice: Double = 0
    private var floorPrice: Double = 0
    private var count: Double = 0
    private var allGetFlag = FlagStruct()
    private var coinCase: CoinType = .eth

    // MARK: init
    init(fp: Double) {
        super.init(nibName: nil, bundle: nil)
        
        self.floorPrice = fp
        mainView.priceTextField.text = "\(fp)"
        mainView.priceTextField.keyboardType = .numbersAndPunctuation
        mainView.priceTextField.delegate = self
        mainView.customSegmentControl.selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getCurrentPrice()
        connect()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        disconnect()
    }
    
    private func getCurrentPrice() {
        
        ProgressHUD.show("가격을 업데이트 중입니다.")
        
        NetworkManager.shared.getCurrentPrice(url: "https://api.bithumb.com/public/transaction_history/ETH_KRW?") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.mainView.ethPriceLabel.text = "이더리움 가격 : \(value.data[0].price)원"
                self.ethPrice = Double(value.data.first?.price ?? "")!
                self.allGetFlag.ethFlag = true
            case .failure(_):
                self.presentDefaultStyleAlertVC(title: "가격 오류", body: "가격을 불러올수없습니다.", buttonTitle: "확인")
            }
        }
        
        NetworkManager.shared.getCurrentPrice(url: "https://api.bithumb.com/public/transaction_history/KLAY_KRW?") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.mainView.klayPriceLabel.text = "클레이 가격 : \(value.data[0].price)원"
                self.klayPrice = Double(value.data.first?.price ?? "")!
                self.allGetFlag.klayFlag = true
                
                ProgressHUD.dismiss()
                self.mainView.calculatorButton.isEnabled = true
            case .failure(_):
                self.presentDefaultStyleAlertVC(title: "가격 오류", body: "가격을 불러올수없습니다.", buttonTitle: "확인")
            }
        }
        
        
    }

    private func configure() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        mainView.calculatorButton.addTarget(self, action: #selector(getPrice), for: .touchUpInside)
        mainView.customSegmentControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
    }

    private func comma(num: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        let result = numberFormatter.string(from: NSNumber(value: num))

        return result
    }

    private func connect() {
        var request = URLRequest(url: URL(string: "wss://pubwss.bithumb.com/pub/ws")!)
        request.timeoutInterval = 10
        webSocket = WebSocket(request: request, certPinner: FoundationSecurity(allowSelfSigned: true))
        webSocket?.delegate = self
        webSocket?.connect()
    }

    private func disconnect() {
        webSocket?.disconnect()
    }

    private func parse(data: Data) {
        print("데이터 : \(data)")
        let decoder = JSONDecoder()
        do {
            let value = try decoder.decode(BithumbModel.self, from: data)
            print(value)
            if value.content.symbol == "ETH_KRW" {
                mainView.ethPriceLabel.text = "이더리움 가격 : \(value.content.openPrice)원"
                ethPrice = Double(value.content.openPrice)!
                allGetFlag.ethFlag = true
            } else if value.content.symbol == "KLAY_KRW" {
                mainView.klayPriceLabel.text = "클레이 가격 : \(value.content.openPrice)원"
                klayPrice = Double(value.content.openPrice)!
                allGetFlag.klayFlag = true
            }
            if allGetFlag.ethFlag {
                mainView.calculatorButton.isEnabled = true
            }

        } catch {
            print("디코딩 error")
        }


    }

    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch(event) {
        case .connected(let headers):
            print(".connected - \(headers)")

            let tickerData = RequestBit(type: "ticker", symbols: ["ETH_KRW", "KLAY_KRW"], tickTypes: ["30M"])
            let jsonTickerData = try! JSONEncoder().encode(tickerData)

            print(jsonTickerData)
            client.write(data: jsonTickerData,completion: nil)

            break
        case .disconnected(let reason, let code):
            print(".disconnected - \(reason), \(code)")
            break
        case .text(let string):
            parse(data: string.data(using: .utf8)!)

            break
        case .binary(let data):
            print("binary:  \(data)")
            parse(data: data)

            break
        case .error(let error):
            print(error?.localizedDescription ?? "")
            break
        default:
            break
        }
    }

    @objc func getPrice() {
        if coinCase == .eth {
            mainView.floorPriceLabel.text = "원화 가격 : \(Int(ethPrice * floorPrice))원"
        } else {
            mainView.floorPriceLabel.text = "원화 가격 : \(Int(klayPrice * floorPrice))원"
        }
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        print("\(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 0 {
            coinCase = .eth
        } else {
            coinCase = .klay
        }
    }
    
}

extension CalculatorVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if !text.isEmpty {
            floorPrice = Double(textField.text!)!
        }
    }
    
}
