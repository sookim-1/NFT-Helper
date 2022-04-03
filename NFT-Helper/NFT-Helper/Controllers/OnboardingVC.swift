//
//  OnboardingVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/03/25.
//

import UIKit

import SnapKit

final class OnboardingVC: UIViewController {

    lazy var nextButton = CustomDefaultStyleButton(backgroundColor: .systemGreen, title: "다음")
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
       
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = .fast
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .systemGray5
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.isEnabled = false
        
        return pageControl
    }()
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpOnboardSlide()
        setUpConstraints()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        [nextButton, collectionView, pageControl].forEach {
            view.addSubview($0)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        nextButton.addTarget(self, action: #selector(clickedNextBtn), for: .touchUpInside)
    }

    private func setUpOnboardSlide() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        paragraphStyle.alignment = .center
        
        let firstOnboardingAttributedString = NSMutableAttributedString(string: "내 자산의 바닥가를 확인하세요!")
        firstOnboardingAttributedString.addAttributes([.foregroundColor: UIColor.systemGreen,
                                                       .kern: -0.5,
                                                       .paragraphStyle: paragraphStyle
                                                      ],
                                                      range: NSRange(location: 0, length: 4))
        
        let secondOnboardingAttributedString = NSMutableAttributedString(string: "민팅 일정을 기록해 보세요")
        secondOnboardingAttributedString.addAttributes([.foregroundColor: UIColor.systemGreen,
                                                       .kern: -0.5,
                                                       .paragraphStyle: paragraphStyle
                                                      ],
                                                      range: NSRange(location: 0, length: 5))
        
        let thirdOnboardingAttributedString = NSMutableAttributedString(string: "실시간 원화가격으로 계산해 보세요")
        
        slides = [
            OnboardingSlide(titleText: firstOnboardingAttributedString, imageName: "metatoy_1"),
            OnboardingSlide(titleText: secondOnboardingAttributedString, imageName: "metatoy_2"),
            OnboardingSlide(titleText: thirdOnboardingAttributedString, imageName: "metatoy_3")
        ]
    }

   @objc func clickedNextBtn(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                windowScene.windows.first?.rootViewController = AddressRegisterVC(isFirst: true)
                windowScene.windows.first?.makeKeyAndVisible()
            }
        }
        else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }

    }
    
    private func setUpConstraints() {
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.bottom.equalTo(nextButton.snp.top).offset(-42)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(-56)
        }
    }

}

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as? OnboardingCollectionViewCell else { return UICollectionViewCell() }

        cell.setup(slides[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
}
