//
//  MedicationCell.swift
//  Drugeroo
//
//  Created by Dylan Maryk on 10/06/2017.
//  Copyright © 2017 drugeroos. All rights reserved.
//

import UIKit

class MedicationCell: UITableViewCell {
    let medicationImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        medicationImageView.frame = CGRect(x: 0, y: 0, width: 375, height: 230)
        medicationImageView.contentMode = .scaleAspectFit
        addSubview(medicationImageView)
    }
}
