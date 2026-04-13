//
//  UITableViewCell+Utils.swift
//  MVVM+Coord
//
//  Created by Eric Vennaro on 1/18/23.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
