//
//  Extensions.swift
//  MetalFurnaceApp
//
//  Created by Tomer Ciucran on 04.01.18.
//  Copyright © 2018 Cihan Muradoglu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func instanceFromNib(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(nibName: nibNamed, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
