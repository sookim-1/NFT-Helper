//
//  OnboardingVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/03/25.
//

import UIKit

final class OnboardingVC: UIViewController {

    private let mainView = OnboardingView()

    private var slides: [OnboardingSlide] = []
    private var currentPage = 0 {
        didSet {
            mainView.pageControl.currentPage = currentPage
        }
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpOnboardSlide()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        mainView.nextButton.addTarget(self, action: #selector(clickedNextBtn), for: .touchUpInside)
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
            OnboardingSlide(titleText: firstOnboardingAttributedString, imageName: "logo"),
            OnboardingSlide(titleText: secondOnboardingAttributedString, imageName: "kaikas"),
            OnboardingSlide(titleText: thirdOnboardingAttributedString, imageName: "metamask")
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
            mainView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
