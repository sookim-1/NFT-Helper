//
//  CalendarVC.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/26.
//

import EventKit
import EventKitUI
import UIKit

class CalendarVC: UIViewController, EKEventViewDelegate {

    let store = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
    }
    
    func configureViewController() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func didTapAdd() {
//        let vc = EKCalendarChooser()
//        vc.showsDoneButton = true
//        vc.showsCancelButton = true
//        present(UINavigationController(rootViewController: vc), animated: true)
        
        store.requestAccess(to: .event) { [weak self] success, error in
            guard let self = self else { return }
            if success, error == nil {
                DispatchQueue.main.async {
                    let newEvent = EKEvent(eventStore: self.store)
                    newEvent.title = "Events Youtube Viedeo"
                    newEvent.startDate = Date()
                    newEvent.endDate = Date()
                    newEvent.location = .none

                    let otherVC = EKEventEditViewController()
                    otherVC.eventStore = self.store
                    otherVC.event = newEvent
                    self.present(otherVC, animated: true)

//                    let vc = EKEventViewController()
//                    vc.delegate = self
//                    vc.event = newEvent
//                    let navVC = UINavigationController(rootViewController: vc)
//                    self.present(navVC, animated: true)
                }
            }
        }
    }
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        print("testtt")
        controller.dismiss(animated: true, completion: nil)
    }
    
}
