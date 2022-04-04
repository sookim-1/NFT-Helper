//
//  UIViewController+Ext.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/26.
//

import UIKit
import SafariServices

import SnapKit
import Toast

fileprivate var containerView: UIView!

extension UIViewController {
    func centerToastMessage(text: String) {
        self.view.makeToast(text, point: self.view.center, title: nil, image: nil, completion: nil)
    }
    
    func presentDefaultStyleAlertVC(title: String, body: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = CustomDefaultStyleAlertVC(title: title, body: body, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            
            self.present(alertVC, animated: true)
        }
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = EmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }

}
