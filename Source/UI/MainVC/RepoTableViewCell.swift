//
//  RepoTableViewCell.swift
//  ISBRequestsManager
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var starsCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func fillWith(_ model: GitRepoCellModel) -> Void {
        self.titleLabel.text = model.name
        self.starsCountLabel.text = String(model.stars)
        self.languageLabel.text = model.devLanguage
    }
}
