//
//  SymbolDetailsViewController.swift
//  StockMarkets Test Project
//
//  Created by Milos Petrusic on 16.6.21..
//

import UIKit

class SymbolDetailsViewController: UIViewController {
    
    var selectedSymbol: Symbol?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var changePercentLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = selectedSymbol?.name
        configUI()
        
    }
    
    private func configUI() {
        let quotes = selectedSymbol?.quote
        dateLabel.text = quotes?.dateTime.changeDateStringFormat()
        lastLabel.text = quotes?.last
        highLabel.text = quotes?.high
        lowLabel.text = quotes?.low
        changeLabel.text = quotes?.change
        changePercentLabel.text = quotes!.changePercent + "%"
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        if let changePercent = quotes?.changePercent {
            if Double(changePercent) ?? 0 > 0 {
                lastLabel.textColor = .green
                changePercentLabel.textColor = .green
                changePercentLabel.text = "+" + changePercentLabel.text!
                changeLabel.text = "+" + changeLabel.text!
                changeLabel.textColor = .green
            } else if Double(changePercent) ?? 0 < 0 {
                lastLabel.textColor = .red
                changePercentLabel.textColor = .red
                changeLabel.textColor = .red
            }
        }
    }

}
