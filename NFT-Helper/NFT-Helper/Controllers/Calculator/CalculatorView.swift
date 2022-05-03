//
//  CalculatorView.swift
//  NFT-Helper
//
//  Created by sookim on 2022/05/03.
//

import UIKit

import SnapKit

final class CalculatorView: UIView, ViewRepresentable {
    
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
        
        return seg
    }()
    
    var floorPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "원화 가격 : "
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .subheadline), size: 20)
        label.textColor = .systemGreen
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubviews(ethPriceLabel, ethImageView, klayPriceLabel, klayImageView, calculatorButton, floorPriceLabel, customSegmentControl, priceTextField)
    }
    
    func setUpLayout() {
        ethPriceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
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

    private func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
