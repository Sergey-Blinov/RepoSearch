//
//  UITableView+Reusable.swift
//  GenericReusable
//
//  Created by Sergey on 11/14/18.
//  Copyright © 2018 sblinov.com. All rights reserved.
//

import UIKit

public extension UITableView {
    final func register<T: UITableViewCell>(_ cellType: T.Type)
        where T: Reusable {
            self.register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func register<T: UITableViewCell>(_ cellType: T.Type)
        where T: Reusable & NibLoadable {
            self.register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func register<T: UITableViewHeaderFooterView>(_ headerFooterViewType: T.Type)
        where T: Reusable & NibLoadable {
            self.register(headerFooterViewType.nib, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
    }
}

