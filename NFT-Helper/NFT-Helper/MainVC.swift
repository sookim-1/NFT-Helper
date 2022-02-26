//
//  MainVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/19.
//

import UIKit

import SnapKit

final class MainVC: UIViewController {

    lazy var logoImageView = UIImageView()
    lazy var walletAddressTextField = CustomDefaultStyleTextField(placeholder: "메타마스크지갑 주소를 입력해주세요")
    lazy var callToActionButton = CustomDefaultStyleButton(backgroundColor: .systemGreen, title: "확인")
    
    // MARK: 뷰컨트롤러 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: UI화면 설정
    
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.image = UIImage(named: "metatoy_2")!
        logoImageView.layer.cornerRadius = 100
        logoImageView.clipsToBounds = true
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
    }
    
    private func configureTextField() {
        view.addSubview(walletAddressTextField)
        
        walletAddressTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(48)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
    }
    
    private func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        
        callToActionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
    }
    
    // MARK: Helper
    
    private func createDismissKeyboardTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        view.addGestureRecognizer(tapGesture)
    }
}

