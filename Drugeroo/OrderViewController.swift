//
//  OrderViewController.swift
//  Drugeroo
//
//  Created by Dylan Maryk on 10/06/2017.
//  Copyright © 2017 drugeroos. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    @IBOutlet var medicationImageView: UIImageView!
    
    var medicationImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicationImageView.image = medicationImage
    }
    
    @IBAction func paypalButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showMap", sender: self)
    }
}
