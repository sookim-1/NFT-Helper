//
//  CalculatorVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/03/25.
//

import UIKit

import Alamofire
import SnapKit
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

class CalculatorVC: UIViewController, WebSocketDelegate {

    var webSocket: WebSocket!

    // MARK: UI 요소
    lazy var ethImageView: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 7))

        img.image = self.resizeImage(image: UIImage(named: "ETH")!, width: 30, height: 30)

        return img
    }()

    var ethPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "이더리움 원화가격"
        return label
    }()

    lazy var klayImageView: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 7))
        img.image = self.resizeImage(image: UIImage(named: "kaikas")!, width: 30, height: 30)

        return img
    }()

    var klayPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "클레이튼 원화가격"
        return label
    }()

    var calculatorButton = CustomDefaultStyleButton(backgroundColor: .systemGreen, title: "계산하기")
    var priceTextField = CustomDefaultStyleTextField(placeholder: "가격을 입력해주세요")
    
    lazy var customSegmentControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["이더리움", "클레이"])
        seg.addTarget(self, action: #selector(indexChanged), for: .valueChanged)

        return seg
    }()
    
    var floorPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "원화 가격 : "
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .subheadline), size: 20)
        label.textColor = .systemGreen
        return label
    }()
    
    // MARK: 기능적 요소

    var ethPrice: Double = 0
    var klayPrice: Double = 0
    var floorPrice: Double = 0
    var count: Double = 0
    var allGetFlag = FlagStruct()
    var coinCase: CoinType = .eth

    // MARK: init
    init(fp: Double) {
        super.init(nibName: nil, bundle: nil)
        
        self.floorPrice = fp
        self.priceTextField.text = "\(fp)"
        self.priceTextField.keyboardType = .numbersAndPunctuation
        self.priceTextField.delegate = self
        self.customSegmentControl.selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 뷰컨트롤러 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setUpLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ProgressHUD.show("가격을 업데이트 중입니다.")
        connect()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        disconnect()
    }

    func configure() {
        view.backgroundColor = .systemBackground
        view.addSubviews(ethPriceLabel, ethImageView, klayPriceLabel, klayImageView, calculatorButton, floorPriceLabel, customSegmentControl, priceTextField)
        calculatorButton.addTarget(self, action: #selector(getPrice), for: .touchUpInside)
    }

    func setUpLayout() {
        ethPriceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }

        klayPriceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
            make.top.equalTo(ethPriceLabel.snp.top).offset(70)
        }

        calculatorButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
            make.top.equalTo(klayPriceLabel.snp.top).offset(70)
        }

        ethImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(ethPriceLabel.snp.left).offset(-4)

            make.top.equalTo(ethPriceLabel.snp.top)
        }

        klayImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(klayPriceLabel.snp.top)
            make.right.equalTo(ethPriceLabel.snp.left).offset(-4)
        }
        
        customSegmentControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(calculatorButton.snp.top).offset(70)
        }
        
        priceTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.top.equalTo(customSegmentControl.snp.top).offset(40)
        }

        floorPriceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)
            make.top.equalTo(priceTextField.snp.top).offset(70)
        }
    }

    func comma(num: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        let result = numberFormatter.string(from: NSNumber(value: num))

        return result
    }

    // MARK: 빗썸 웹소켓 연결

    func connect() {
        var request = URLRequest(url: URL(string: "wss://pubwss.bithumb.com/pub/ws")!)
        request.timeoutInterval = 10
        webSocket = WebSocket(request: request, certPinner: FoundationSecurity(allowSelfSigned: true))
        webSocket?.delegate = self
        webSocket?.connect()
    }

    func disconnect() {
        webSocket?.disconnect()
    }

    func parse(data: Data) {
        print("데이터 : \(data)")
        let decoder = JSONDecoder()
        do {
            let value = try decoder.decode(Post2.self, from: data)
            print(value)
            if value.content.symbol == "ETH_KRW" {
                ethPriceLabel.text = "이더리움 가격 : \(value.content.openPrice)원"
                ethPrice = Double(value.content.openPrice)!
                allGetFlag.ethFlag = true
            } else if value.content.symbol == "KLAY_KRW" {
                klayPriceLabel.text = "클레이 가격 : \(value.content.openPrice)원"
                klayPrice = Double(value.content.openPrice)!
                allGetFlag.klayFlag = true
            }
            if allGetFlag.ethFlag {
                ProgressHUD.dismiss()
                calculatorButton.isEnabled = true
            }

        } catch {
            print("디코딩 error")
        }


    }

    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch(event) {
        case .connected(let headers):
            print(".connected - \(headers)")

            let a = RequestBit(type: "ticker", symbols: ["ETH_KRW", "MATIC_KRW", "KLAY_KRW"], tickTypes: ["30M"])
            let jsonData = try! JSONEncoder().encode(a)

            print(jsonData) // 47 bytes
            client.write(data: jsonData,completion: nil)

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
            floorPriceLabel.text = "원화 가격 : \(Int(ethPrice * floorPrice))원"
        } else {
            floorPriceLabel.text = "원화 가격 : \(Int(klayPrice * floorPrice))원"
        }
    }
    
    // MARK: Helper
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        print("\(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 0 {
            coinCase = .eth
        } else {
            coinCase = .klay
        }
    }

    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

// MARK: TextField
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


// MARK: - Model
struct Post2: Codable {
    let type: String
    let content: Content
}

struct Content: Codable {
    let tickType, date, time, openPrice: String
    let closePrice, lowPrice, highPrice, value: String
    let volume, sellVolume, buyVolume, prevClosePrice: String
    let chgRate, chgAmt, volumePower, symbol: String
}

struct RequestBit: Codable {
    let type: String
    let symbols: [String]
    let tickTypes: [String]
}
