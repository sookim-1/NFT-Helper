//
//  ViewController.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/19.
//

import UIKit

import Alamofire
import SnapKit
import Starscream
import ProgressHUD

struct FlagStruct {
    var ethFlag: Bool = false
    var polygonFlag: Bool = false
    var klayFlag: Bool = false
    
    func allTrue() -> Bool {
        if ethFlag == true && polygonFlag == true && klayFlag == true {
            return true
        }
        return false
    }
}

class ViewController: UIViewController, WebSocketDelegate {
    var webSocket: WebSocket!
    
    lazy var ethImageView: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 7))
        
        img.image = self.resizeImage(image: UIImage(named: "eth")!, width: 30, height: 30)

        
        return img
    }()
    
    var ethPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "이더가격"
        return label
    }()
    
    lazy var polygonImageView: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 7))
        img.image = self.resizeImage(image: UIImage(named: "polygon")!, width: 30, height: 30)

        
        return img
    }()

    
    var polygonPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "폴리곤가격"
        return label
    }()
    
    lazy var klayImageView: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 7))
        img.image = self.resizeImage(image: UIImage(named: "klay")!, width: 30, height: 30)

        
        return img
    }()

    
    var klayPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "클레이가격"
        return label
    }()
    
    var button: UIButton = {
        let btn = UIButton()
        btn.setTitle("가격 물어보기", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.isEnabled = false
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    lazy var resultImageView: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 7))
        
        img.image = UIImage(named: "img")

        
        return img
    }()
    
    var ethPrice: Double = 0
    var polygonPrice: Double = 0
    var klayPrice: Double = 0
    var floorPrice: Double = 0
    var count: Double = 0
    var allGetFlag = FlagStruct()
    
    var floorPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "용가리 한개당 가격 : "
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .subheadline), size: 20)
        label.textColor = .systemGreen
        return label
    }()
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
        view.addSubview(ethPriceLabel)
        view.addSubview(polygonPriceLabel)
        view.addSubview(klayPriceLabel)
        view.addSubview(button)
        view.addSubview(floorPriceLabel)
        
        view.addSubview(ethImageView)
        view.addSubview(polygonImageView)
        view.addSubview(klayImageView)
        view.addSubview(resultImageView)
        
        button.addTarget(self, action: #selector(getPrice), for: .touchUpInside)
    }
    
    func setUpLayout() {
        ethPriceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        polygonPriceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
            make.top.equalTo(ethPriceLabel.snp.top).offset(70)
        }
        klayPriceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
            make.top.equalTo(polygonPriceLabel.snp.top).offset(70)
        }
        
        button.snp.makeConstraints { make in
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
        
        polygonImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(polygonPriceLabel.snp.left).offset(-4)
            
            make.top.equalTo(polygonPriceLabel.snp.top)
        }
        
        klayImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(klayPriceLabel.snp.top)
            make.right.equalTo(polygonPriceLabel.snp.left).offset(-4)
        }
        
        resultImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.top).offset(70)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        
        floorPriceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)
            make.top.equalTo(resultImageView.snp.top).offset(70)
        }
    }
    
    // Opensea.io 가격
    func getFloorPrice() {
        AF.request("https://api.opensea.io/api/v1/collection/mtdz-1/stats", method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: OpenSea.self) { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    for (key, value) in data.stats {
                        if key == "floor_price" {

                            self.floorPrice = value
                            let a = (self.floorPrice) * (self.ethPrice)
                            self.floorPriceLabel.text = "용가리 한개당 가격 : \(self.comma(num: Int(a))!) 원"
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
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
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
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
            print("text:  \(string.data(using: .utf8))")
            
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
    
    func parse(data: Data) {
        print("데이터 : \(data)")
        let decoder = JSONDecoder()
        do {
            let value = try decoder.decode(Post.self, from: data)
            print(value)
            if value.content.symbol == "ETH_KRW" {
                ethPriceLabel.text = "이더리움 가격 : \(value.content.openPrice)원"
                ethPrice = Double(value.content.openPrice)!
                allGetFlag.ethFlag = true
            } else if value.content.symbol == "KLAY_KRW" {
                klayPriceLabel.text = "클레이 가격 : \(value.content.openPrice)원"
                klayPrice = Double(value.content.openPrice)!
                allGetFlag.klayFlag = true
            } else if value.content.symbol == "MATIC_KRW" {
                polygonPriceLabel.text = "폴리곤 가격 : \(value.content.openPrice)원"
                polygonPrice = Double(value.content.openPrice)!
                allGetFlag.polygonFlag = true
            }
            
            if allGetFlag.ethFlag {
                ProgressHUD.dismiss()
                button.isEnabled = true
            }
            
        } catch {
            print("디코딩 error")
        }
        
    
    }

    @objc func getPrice() {
        getFloorPrice()
    }
    
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

// MARK: - Post
struct Post: Codable {
    let type: String
    let content: Content
}

// MARK: - Content
struct Content: Codable {
    let tickType, date, time, openPrice: String
    let closePrice, lowPrice, highPrice, value: String
    let volume, sellVolume, buyVolume, prevClosePrice: String
    let chgRate, chgAmt, volumePower, symbol: String
}


// MARK: - Request
struct RequestBit: Codable {
    let type: String
    let symbols: [String]
    let tickTypes: [String]
}

// MARK: - OpenSea
struct OpenSea: Codable {
    let stats: [String: Double]
}
