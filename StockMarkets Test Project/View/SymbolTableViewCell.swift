//
//  SymbolTableViewCell.swift
//  StockMarkets Test Project
//
//  Created by Milos Petrusic on 16.6.21..
//

import UIKit

class SymbolTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolTitle: UILabel!
    @IBOutlet weak var firstValueLabel: UILabel!
    @IBOutlet weak var secondValueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        symbolTitle.minimumScaleFactor = 0.5
        symbolTitle.adjustsFontSizeToFitWidth = true
        firstValueLabel.minimumScaleFactor = 0.5
        firstValueLabel.adjustsFontSizeToFitWidth = true
        secondValueLabel.minimumScaleFactor = 0.5
        secondValueLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
