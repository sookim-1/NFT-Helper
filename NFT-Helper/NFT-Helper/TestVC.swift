//
//  TestVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/21.
//

import UIKit
import SnapKit

class TestVC: UIViewController {

    let cardView = CardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(cardView)
        cardView.backgroundColor = .systemPink
        cardView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    

}

class CardView: UIView {
    // 배경 이미지뷰
    lazy var backgroundImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "sesac_background_1")
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
        
        return img
    }()

    // 새싹 프로필 이미지뷰
    lazy var sesacImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "sesac_face_1")
        
        return img
    }()
    
    // 요청하기, 수락하기 버튼
    lazy var decisionButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .systemFont(ofSize: 20)
        btn.backgroundColor = .systemPink
        btn.setTitle("요청하기", for: .normal)
        
        return btn
    }()
    
    
    // 바텀뷰
    private let bottomView = BottomView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(backgroundImageView)
        addSubview(sesacImageView)
        addSubview(decisionButton)
        addSubview(bottomView)
        
        bottomView.layer.cornerRadius = 8
        decisionButton.addTarget(self, action: #selector(touchDecisionButton), for: .touchUpInside)
    }
    
    func setUpLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundImageView.snp.centerX)
            make.height.equalTo(backgroundImageView.snp.height).multipliedBy(0.8)
            make.width.equalTo(sesacImageView.snp.height)
            make.bottom.equalTo(backgroundImageView.snp.bottom)
        }
        
        decisionButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.top.equalTo(backgroundImageView.snp.top).offset(12)
            make.right.equalTo(backgroundImageView.snp.right).offset(-12)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView.snp.left)
            make.right.equalTo(backgroundImageView.snp.right)
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func touchDecisionButton() {
        print("터치")
    }
}

class BottomView: UIView {
    lazy var titleLable: UILabel = {
        let lbl = UILabel()
        lbl.text = "뭉치뭉치" // 닉네임
        return lbl
    }()
    
    lazy var arrowButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        btn.setImage(UIImage(systemName: "arrow.up"), for: .selected)
        
        btn.tintColor = .systemBlue
        return btn
    }()
    
    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLable, arrowButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        
        return stackView
    }()
    
    // 서브 제목
    
    lazy var sesacTitleLable: UILabel = {
        let lbl = UILabel()
        lbl.text = "새싹 타이틀"
        return lbl
    }()
    
    lazy var titleView = TitleView()
    
    lazy var hobbyLable: UILabel = {
        let lbl = UILabel()
        lbl.text = "하고 싶은 취미"
        return lbl
    }()
    
    lazy var hobbyView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        
        return view
    }()
    
    lazy var sesacReviewLable: UILabel = {
        let lbl = UILabel()
        lbl.text = "새싹 리뷰"
        return lbl
    }()
    
    lazy var reviewView: UITextView = {
        let view = UITextView()
        view.text = "첫 리뷰를 기다리는 중이에요!"
        view.textColor = .systemBlue
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        addSubview(titleStackView)
        addSubview(sesacTitleLable)
        addSubview(titleView)
        addSubview(hobbyLable)
        addSubview(hobbyView)
        addSubview(sesacReviewLable)
        addSubview(reviewView)
    }
    
    func setUpLayout() {
        titleLable.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalTo(arrowButton.snp.left)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(16)
            make.height.equalTo(16)
            make.right.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        sesacTitleLable.snp.makeConstraints { make in
            make.left.equalTo(titleStackView.snp.left)
            make.right.equalTo(titleStackView.snp.right)
            make.top.equalTo(titleStackView.snp.bottom).offset(10)
        }
        
        titleView.snp.makeConstraints { make in
            make.left.equalTo(titleStackView.snp.left)
            make.right.equalTo(titleStackView.snp.right)
            make.top.equalTo(sesacTitleLable.snp.bottom).offset(10)
            make.height.greaterThanOrEqualTo(50).priority(.low)
        }
        
        hobbyLable.snp.makeConstraints { make in
            make.left.equalTo(titleStackView.snp.left)
            make.right.equalTo(titleStackView.snp.right)
            make.top.equalTo(titleView.snp.bottom)
        }
        
        hobbyView.snp.makeConstraints { make in
            make.left.equalTo(titleStackView.snp.left)
            make.right.equalTo(titleStackView.snp.right)
            make.top.equalTo(hobbyLable.snp.bottom).offset(10)
            make.height.greaterThanOrEqualTo(50).priority(.high)
        }
        
        sesacReviewLable.snp.makeConstraints { make in
            make.left.equalTo(titleStackView.snp.left)
            make.right.equalTo(titleStackView.snp.right)
            make.top.equalTo(hobbyView.snp.bottom)
        }
        
        reviewView.snp.makeConstraints { make in
            make.left.equalTo(titleStackView.snp.left)
            make.right.equalTo(titleStackView.snp.right)
            make.top.equalTo(sesacReviewLable.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}

class TitleView: UIView {
    lazy var mannerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("좋은 매너", for: .normal)
        btn.titleLabel?.textColor = .black
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemGray4.cgColor
        
        return btn
    }()
    
    lazy var clockButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("정확한 시간 약속", for: .normal)
        btn.titleLabel?.textColor = .black
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemGray4.cgColor
        
        return btn
    }()
    
    lazy var fastButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("빠른 응답", for: .normal)
        btn.titleLabel?.textColor = .black
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemGray4.cgColor
        
        return btn
    }()
    
    lazy var kindButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("친절한 성격", for: .normal)
        btn.titleLabel?.textColor = .black
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemGray4.cgColor
        
        return btn
    }()
    
    lazy var hobbyButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("능숙한 취미 실력", for: .normal)
        btn.titleLabel?.textColor = .black
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemGray4.cgColor
        
        return btn
    }()
    
    lazy var timeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("유익한 시간", for: .normal)
        btn.titleLabel?.textColor = .black
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemGray4.cgColor
        
        return btn
    }()
    
    var buttons: [UIButton]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        buttons = [mannerButton, clockButton, fastButton, kindButton, hobbyButton, timeButton]
        
        buttons.forEach { btn in
            addSubview(btn)
            btn.backgroundColor = .systemGreen
        }
    }
    
    func setUpLayout() {
        // 1
        mannerButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalTo(clockButton.snp.left).offset(-20)
        }
        
        clockButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(mannerButton.snp.width)
        }
        
        // 2
        fastButton.snp.makeConstraints { make in
            make.left.equalTo(mannerButton.snp.left)
            make.top.equalTo(mannerButton.snp.bottom).offset(20)
            make.right.equalTo(kindButton.snp.left).offset(-20)
            make.width.equalTo(mannerButton.snp.width)
        }
        
        kindButton.snp.makeConstraints { make in
            make.right.equalTo(clockButton.snp.right)
            make.top.equalTo(fastButton.snp.top)
            make.width.equalTo(mannerButton.snp.width)
        }
        
        // 3
        hobbyButton.snp.makeConstraints { make in
            make.left.equalTo(mannerButton.snp.left)
            make.top.equalTo(fastButton.snp.bottom).offset(20)
            make.right.equalTo(timeButton.snp.left).offset(-20)
            make.width.equalTo(mannerButton.snp.width)
            make.bottom.equalToSuperview()
        }
        
        timeButton.snp.makeConstraints { make in
            make.right.equalTo(kindButton.snp.right)
            make.top.equalTo(hobbyButton.snp.top)
            make.bottom.equalTo(hobbyButton.snp.bottom)
            make.width.equalTo(mannerButton.snp.width)
        }
    }
}
