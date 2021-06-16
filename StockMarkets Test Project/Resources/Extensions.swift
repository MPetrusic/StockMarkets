//
//  Extensions.swift
//  StockMarkets Test Project
//
//  Created by Milos Petrusic on 16.6.21..
//

import UIKit

extension String {
    
    func changeDateStringFormat(fromFormat sourceFormat : String? = "yyyy-MM-dd'T'HH:mm:ss", toFormat desFormat: String? = "MM-dd-yyyy HH:mm") -> String? {
        
        // From
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = sourceFormat
        
        // To
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = desFormat
        
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
