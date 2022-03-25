//
//  AddressRegisterVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/03/25.
//

import UIKit

import SnapKit

enum AddressType {
    case none
    case metamask
    case kaikas
}

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
    
    lazy var addressStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [metamaskView, kaikasView])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    private var addressType: AddressType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configure()
        setUpConstraints()
        configureTextField()
    }

    private func configure() {
        view.addSubview(authDescriptionLabel)
        view.addSubview(addressStackView)
        view.addSubview(walletAddressTextField)
        view.addSubview(registerButton)
        
        metamaskView.addSubview(metamaskImageView)
        metamaskView.addSubview(metamaskLabel)
        kaikasView.addSubview(kaikasImageView)
        kaikasView.addSubview(kaikasLabel)
        
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
        switch addressType {
        case .none:
            print("none")
        case .metamask:
            UserDefaults.matamaskAddress = walletAddressTextField.text
        case .kaikas:
            UserDefaults.kaikasAddress =  walletAddressTextField.text
        }
        
        present(MainVC(), animated: true)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("메타마스크 등록", walletAddressTextField.text!)
        addressType = .metamask
        metamaskView.backgroundColor = .systemGreen.withAlphaComponent(0.7)
        kaikasView.backgroundColor = .systemBackground
        
    }
    
    @objc func handleTap2(sender: UITapGestureRecognizer) {
        print("카이카스 등록", walletAddressTextField.text!)
        addressType = .kaikas
        kaikasView.backgroundColor = .systemGreen.withAlphaComponent(0.7)
        metamaskView.backgroundColor = .systemBackground
    }
    
}

extension AddressRegisterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        present(MainVC(), animated: true)
        
        return true
    }
}
