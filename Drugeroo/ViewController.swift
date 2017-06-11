//
//  ViewController.swift
//  Drugeroo
//
//  Created by Dylan Maryk on 10/06/2017.
//  Copyright © 2017 drugeroos. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var medicationTableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    
    var medicationImageSelected: UIImage!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        medicationTableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let cell = self.medicationTableView.cellForRow(at: indexPath) as! MedicationCell
            self.medicationImageSelected = cell.medicationImageView.image
            self.performSegue(withIdentifier: "showWarning", sender: self)
        }).disposed(by: disposeBag)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let warningVC = segue.destination as! WarningViewController
        warningVC.medicationImage = medicationImageSelected
    }
}

