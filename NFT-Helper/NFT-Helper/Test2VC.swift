//
//  Test2VC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/22.
//

import UIKit

import SnapKit

class Test2VC: UIViewController, TapViewDelegate {


    private var seg = CustomTapView(frame: .zero, buttonTitle: ["주변 새싹", "받은 요청"])
    private var secondView = UIView()
    private var thirdView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "새싹 찾기"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopFindRequest))
        
        seg.delegate = self
        seg.backgroundColor = .clear
        view.addSubview(seg)
        seg.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        setA()
    }
    
    @objc func stopFindRequest() {
        print("test")
    }
    
    func change(to index: Int) {
        if index == 1 {
            secondView.removeFromSuperview()
            thirdView.backgroundColor = .systemRed
            
            view.addSubview(thirdView)
            
            thirdView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(seg.snp.bottom).offset(10)
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        } else {
            setA()
        }
    }
    
    func setA() {
        thirdView.removeFromSuperview()
        secondView.backgroundColor = .systemBlue
        
        view.addSubview(secondView)
        
        secondView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(seg.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

protocol TapViewDelegate: AnyObject {
    func change(to index: Int)
}

final class CustomTapView: UIView {

    private var buttonTitles: [String]!
    private var buttons: [UIButton]!
    public private(set) var selectorView: UIView!
    
    var textColor: UIColor = .gray
    var selectorViewColor: UIColor = .green
    var selectorTextColor: UIColor = .green
    
    weak var delegate: TapViewDelegate?
    
    public private(set) var selectedIndex: Int = 0
    
    convenience init(frame: CGRect, buttonTitle: [String]) {
        self.init(frame: frame)
        
        self.buttonTitles = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.backgroundColor = .white
        updateView()
    }
    
    func setButtonTitles(buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
    func setIndex(index: Int) {
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition
        }
    }
    
    @objc func buttonAction(sender: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
    
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
    }
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 0
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 2))
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({ $0.removeFromSuperview() })
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(CustomTapView.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }

}
