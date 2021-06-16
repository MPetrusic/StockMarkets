//
//  ProfileViewController.swift
//  StockMarkets Test Project
//
//  Created by Milos Petrusic on 16.6.21..
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.borderColor = UIColor.darkGray.cgColor
    }

}
