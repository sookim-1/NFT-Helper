//
//  CalendarFooterView.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/10.
//

import UIKit

import SnapKit

class CalendarPickerFooterView: UIView {
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.label.withAlphaComponent(0.2)
        
        return view
    }()
    
    lazy var previousMonthButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.titleLabel?.textAlignment = .left
        
        if let chevronImage = UIImage(systemName: "chevron.left.circle.fill") {
            let imageAttachment = NSTextAttachment(image: chevronImage)
            let attributedString = NSMutableAttributedString()
            
            attributedString.append(
                NSAttributedString(attachment: imageAttachment)
            )
            
            attributedString.append(
                NSAttributedString(string: " Previous")
            )
            
            button.setAttributedTitle(attributedString, for: .normal)
        } else {
            button.setTitle("Previous", for: .normal)
        }
        
        button.titleLabel?.textColor = .label
        
        button.addTarget(self, action: #selector(didTapPreviousMonthButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.titleLabel?.textAlignment = .right
        
        if let chevronImage = UIImage(systemName: "chevron.right.circle.fill") {
            let imageAttachment = NSTextAttachment(image: chevronImage)
            let attributedString = NSMutableAttributedString(string: "Next ")
            
            attributedString.append(
                NSAttributedString(attachment: imageAttachment)
            )
            
            button.setAttributedTitle(attributedString, for: .normal)
        } else {
            button.setTitle("Next", for: .normal)
        }
        
        button.titleLabel?.textColor = .label
        
        button.addTarget(self, action: #selector(didTapNextMonthButton), for: .touchUpInside)
        
        return button
    }()
    
    let didTapLastMonthCompletionHandler: (() -> Void)
    let didTapNextMonthCompletionHandler: (() -> Void)
    
    init(didTapLastMonthCompletionHandler: @escaping (() -> Void), didTapNextMonthCompletionHandler: @escaping (() -> Void)) {
        self.didTapLastMonthCompletionHandler = didTapLastMonthCompletionHandler
        self.didTapNextMonthCompletionHandler = didTapNextMonthCompletionHandler
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = .systemGroupedBackground
        
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerCurve = .continuous
        layer.cornerRadius = 15
        
        addSubviews(separatorView, previousMonthButton, nextMonthButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var previousOrientation: UIDeviceOrientation = UIDevice.current.orientation
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let smallDevice = UIScreen.main.bounds.width <= 350
        
        let fontPointSize: CGFloat = smallDevice ? 14 : 17
        
        previousMonthButton.titleLabel?.font = .systemFont(ofSize: fontPointSize, weight: .medium)
        nextMonthButton.titleLabel?.font = .systemFont(ofSize: fontPointSize, weight: .medium)
        
        separatorView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1)
        }
        
        previousMonthButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        nextMonthButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func didTapPreviousMonthButton() {
        didTapLastMonthCompletionHandler()
    }
    
    @objc func didTapNextMonthButton() {
        didTapNextMonthCompletionHandler()
    }
    
}
