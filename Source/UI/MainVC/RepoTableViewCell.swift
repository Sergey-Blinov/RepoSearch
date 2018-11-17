//
//  RepoTableViewCell.swift
//  ISBRequestsManager
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var starsCountLabel: UILabel!
    
    func fillWith(_ model: GitRepoViewModel) {
        self.titleLabel.text = model.name
        self.starsCountLabel.text = model.stars
        self.languageLabel.text = model.devLanguage
    }
}
