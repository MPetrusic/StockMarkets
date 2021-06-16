//
//  NewsDetailsViewController.swift
//  StockMarkets Test Project
//
//  Created by Milos Petrusic on 16.6.21..
//

import UIKit

class NewsDetailsViewController: UIViewController {
    
    @IBOutlet weak var newsHeadline: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    var selectedNews: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://cdn.ttweb.net/News/images/" + selectedNews!.imageId + ".jpg?preset=w220_q40")
        if let safeUrl = url {
            newsImageView.load(url: safeUrl)
        }
        newsImageView.contentMode = .scaleAspectFill
        newsHeadline.text = selectedNews?.headline
    }
}
