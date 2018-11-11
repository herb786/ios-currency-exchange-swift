//
//  CurrencyRateTableViewCell.swift
//  XRateTinSwift
//
//  Created by Herbert Caller on 05/09/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

import UIKit

class CurrencyRateTableViewCell: UITableViewCell {
    
    @IBOutlet var flag: UIImageView!
    @IBOutlet var lblValue: UILabel!
    @IBOutlet var lblCode: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
