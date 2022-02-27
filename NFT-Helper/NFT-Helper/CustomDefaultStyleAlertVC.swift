//
//  CustomDefaultStyleAlertVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/26.
//

import UIKit

import SnapKit

final class CustomDefaultStyleAlertVC: UIViewController {
    
    lazy var containerView = UIView()
    lazy var titleLabel = CustomDefaultStyleTitleLabel(textAlignment: .center, fontSize: 20)
    lazy var bodyLabel = CustomDefaultStyleBodyLabel(textAlignment: .center)
    lazy var actionButton = CustomDefaultStyleButton(backgroundColor: .systemPink, title: "확인")

    private var alertTitle: String?
    private var alertBody: String?
    private var buttonTitle: String?
    
    private let padding: CGFloat = 20
    
    init(title: String, body: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertTitle = title
        self.alertBody = body
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 뷰컨트롤러 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureBodyLabel()
    }

    // MARK: UI 화면 설정
    
    private func configureContainerView() {
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(220)
        }
    }

    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        
        titleLabel.text = alertTitle ?? "잘못된 제목입니다."
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(padding)
            make.left.equalTo(containerView.snp.left).offset(padding)
            make.right.equalTo(containerView.snp.right).offset(-padding)
            make.height.equalTo(28)
        }
    }

    private func configureActionButton() {
        containerView.addSubview(actionButton)
        
        actionButton.setTitle(buttonTitle ?? "확인", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerView.snp.bottom).offset(-padding)
            make.left.equalTo(containerView.snp.left).offset(padding)
            make.right.equalTo(containerView.snp.right).offset(-padding)
            make.height.equalTo(44)
        }
    }

    private func configureBodyLabel() {
        containerView.addSubview(bodyLabel)
        
        bodyLabel.text = alertBody ?? "잘못된 본문입니다."
        bodyLabel.numberOfLines = 4
        
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(containerView.snp.left).offset(padding)
            make.right.equalTo(containerView.snp.right).offset(-padding)
            make.bottom.equalTo(actionButton.snp.top).offset(-12)
        }
    }

    // MARK: Helper
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
