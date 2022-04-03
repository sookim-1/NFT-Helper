//
//  AddressRegisterVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/03/25.
//

import UIKit

import SnapKit

final class AddressRegisterVC: UIViewController {
    lazy var authDescriptionLabel = CustomDefaultStyleTitleLabel(textAlignment: .center, fontSize: 24)
    lazy var walletAddressTextField = CustomDefaultStyleTextField(placeholder: "지갑주소를 입력해주세요")
    
    lazy var metamaskView: UIView = {
        let view = UIView()

        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    lazy var kaikasView: UIView = {
        let view = UIView()

        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private let metamaskImageView = UIImageView(image: UIImage(named: "metamask"))
    private let metamaskLabel = UILabel()
    private let kaikasImageView = UIImageView(image: UIImage(named: "kaikas"))
    private let kaikasLabel = UILabel()

    private let registerButton: CustomDefaultStyleButton = CustomDefaultStyleButton(backgroundColor: .systemGreen, title: "등록하기")
    var isFirst: Bool?
    
    lazy var addressStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [metamaskView, kaikasView])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    private var addressType: AddressType = .none
    
    init(isFirst: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        self.isFirst = isFirst
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpConstraints()
        configureTextField()
    }

    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubviews(authDescriptionLabel, addressStackView, walletAddressTextField, registerButton)
        metamaskView.addSubviews(metamaskImageView, metamaskLabel)
        kaikasView.addSubviews(kaikasImageView, kaikasLabel)
        
        authDescriptionLabel.text = "지갑주소를 등록해주세요\n생략 가능"
        authDescriptionLabel.numberOfLines = 0
        
        metamaskLabel.text = "메타마스크"
        kaikasLabel.text = "카이카스"
        
        registerButton.addTarget(self, action: #selector(presentNextVC), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        metamaskView.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(handleTap2(sender:)))
        kaikasView.addGestureRecognizer(tapGesture2)
    }
    
    private func configureTextField() {
        walletAddressTextField.delegate = self
        walletAddressTextField.returnKeyType = .go
        walletAddressTextField.clearButtonMode = .whileEditing
    }
    
    private func setUpConstraints() {
        authDescriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(registerButton.snp.left)
            make.right.equalTo(registerButton.snp.right)
            make.bottom.equalTo(addressStackView.snp.top).offset(-100)
            make.height.equalTo(100)
        }
        
        addressStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(addressStackView.snp.width).multipliedBy(0.5)
        }
        
        metamaskImageView.snp.makeConstraints { make in
            make.centerX.equalTo(metamaskView.snp.centerX)
            make.top.equalTo(metamaskView.snp.top).offset(10)
            make.width.equalTo(metamaskImageView.snp.height).multipliedBy(1.0 / 1.0)
            make.bottom.equalTo(metamaskLabel.snp.top).offset(10)
        }
    
        metamaskLabel.snp.makeConstraints { make in
            make.centerX.equalTo(metamaskView.snp.centerX)
            make.bottom.equalTo(metamaskView.snp.bottom).offset(10)
        }
        
        kaikasImageView.snp.makeConstraints { make in
            make.centerX.equalTo(kaikasView.snp.centerX)
            make.top.equalTo(kaikasView.snp.top).offset(10)
            make.width.equalTo(kaikasImageView.snp.height).multipliedBy(1.0 / 1.0)
            make.bottom.equalTo(kaikasLabel.snp.top).offset(10)
        }
    
        kaikasLabel.snp.makeConstraints { make in
            make.centerX.equalTo(kaikasView.snp.centerX)
            make.bottom.equalTo(kaikasView.snp.bottom).offset(10)
        }
        
        walletAddressTextField.snp.makeConstraints { make in
            make.bottom.equalTo(registerButton.snp.top).offset(-48)
            make.left.equalTo(registerButton.snp.left)
            make.right.equalTo(registerButton.snp.right)
            make.height.equalTo(50)
        }
        
        registerButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
        }
    }
    
    @objc func presentNextVC() {
        
        if (addressType != .none) && !isValidAddress(text: walletAddressTextField.text) {
            self.presentDefaultStyleAlertVC(title: "에러", body: "지갑주소형식이 잘못되었습니다.", buttonTitle: "확인")
        } else {
            if isFirst! {
                UserDefaults.walletAddress = walletAddressTextField.text
                
                presentTabbarVC()
            }
            else {
                let model = WalletAddress(address: walletAddressTextField.text!, type: addressType)
                PersistenceManager.updateWith(addressModel: model, actionType: .add) { error in
                    guard let _ = error else {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                        return
                    }
                    print("에러")
                }
            }
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        addressType = .metamask
        metamaskView.backgroundColor = .systemGreen.withAlphaComponent(0.7)
        kaikasView.backgroundColor = .systemBackground
    }
    
    @objc func handleTap2(sender: UITapGestureRecognizer) {
        addressType = .kaikas
        kaikasView.backgroundColor = .systemGreen.withAlphaComponent(0.7)
        metamaskView.backgroundColor = .systemBackground
    }
    
    private func isValidAddress(text: String?) -> Bool {
        let addressRegEx = "^0x[a-fA-F0-9]{40}$"
        let addressValid = NSPredicate(format: "SELF MATCHES %@", addressRegEx)
        
        return addressValid.evaluate(with: text)
    }
    
    private func presentTabbarVC() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            windowScene.windows.first?.rootViewController = CustomTabBarController()
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }
    
}

extension AddressRegisterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presentTabbarVC()
        
        return true
    }
}
