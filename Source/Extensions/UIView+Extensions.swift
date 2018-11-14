//
//  UIView+Extensions.swift
//  GenericReusable
//
//  Created by Sergey on 11/14/18.
//  Copyright © 2018 sblinov.com. All rights reserved.
//

import UIKit

public typealias NibReusable = Reusable & NibLoadable

public protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public protocol NibLoadable: class {
    static var nib: UINib { get }
}

public extension NibLoadable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

public extension NibLoadable where Self: UIView {
    static func loadFromNib() -> Self {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? Self else {
            fatalError("Error loading nib with name \(String(describing: self))")
        }
        return view
    }
}
