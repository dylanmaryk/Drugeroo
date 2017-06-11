//
//  WarningViewController.swift
//  Drugeroo
//
//  Created by Dylan Maryk on 10/06/2017.
//  Copyright © 2017 drugeroos. All rights reserved.
//

import UIKit

class WarningViewController: UIViewController {
    @IBOutlet weak var medicationImageView: UIImageView!
    
    var medicationImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicationImageView.image = medicationImage
        medicationImageView.frame = CGRect(x: medicationImageView.frame.origin.x,
                                           y: medicationImageView.frame.origin.y,
                                           width: medicationImageView.frame.size.width,
                                           height: medicationImage.size.height - 53)
    }
    
    @IBAction func pickUpButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showOrder", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let orderVC = segue.destination as! OrderViewController
        orderVC.medicationImage = medicationImage
    }
}
