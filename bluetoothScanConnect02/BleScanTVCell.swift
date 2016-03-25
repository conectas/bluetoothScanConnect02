//
//  BleScanTVCell.swift
//  bluetoothScanConnect02
//
//  Created by Stefan Glaser on 28.02.16.
//  Copyright © 2016 conectas. All rights reserved.
//

import UIKit

class BleScanTVCell: UITableViewCell {

    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var uuidOutlet: UILabel!
    @IBOutlet weak var rssiOutlet: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
