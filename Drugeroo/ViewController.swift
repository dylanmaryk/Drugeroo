//
//  ViewController.swift
//  Drugeroo
//
//  Created by Dylan Maryk on 10/06/2017.
//  Copyright © 2017 drugeroos. All rights reserved.
//

import PusherSwift
import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController, PusherDelegate {
    @IBOutlet var categoryTableView: UITableView!
    @IBOutlet var medicationTableView: UITableView!
    @IBOutlet var tabBar: UITabBar!
    
    var pusher: Pusher!
    var channel: PusherChannel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pusher = Pusher(key: "b91115f15fb79204ed0d",
                        options: PusherClientOptions(authMethod: .endpoint(authEndpoint: "https://secure-temple-86252.herokuapp.com/pusher/auth"),
                                                     host: .cluster("eu")))
        pusher.delegate = self
        pusher.connect()
        
        channel = pusher?.subscribe("private-my-channel")
        
        let categories = ["Drugs","Natural remedies","Bach flowers - Rescue","Homeopathy","Diabetes","Overweight & Nutrition","Vitamins & Minerals","Cosmetics","Body care","Mother and child","Medical devices","Incontinence","First aid & Nursing","Veterinary medicines","Medicine chest","GIFT IDEAS"]
        Observable.just(categories).bind(to: categoryTableView.rx.items(cellIdentifier: "CategoryCell",
                                                                        cellType: UITableViewCell.self)) { _, category, cell in
                                                                            cell.textLabel?.text = category
            }.disposed(by: disposeBag)
        
        let medications = [UIImage(named: "medicationOne"), UIImage(named: "medicationTwo")]
        Observable.just(medications).bind(to: medicationTableView.rx.items(cellIdentifier: "MedicationCell",
                                                                           cellType: MedicationCell.self)) { _, medication, cell in
                                                                            cell.medicationImageView.image = medication
            }.disposed(by: disposeBag)
        
        tabBar.selectedItem = tabBar.items?.first
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            categoryTableView.isHidden = false
            medicationTableView.isHidden = true
        } else {
            categoryTableView.isHidden = true
            medicationTableView.isHidden = false
        }
    }
    
    func subscribedToChannel(name: String) {
        channel.trigger(eventName: "client-my-event", data: ["key" : "value"])
    }
    
    func debugLog(message: String) {
        print(message)
    }
}

