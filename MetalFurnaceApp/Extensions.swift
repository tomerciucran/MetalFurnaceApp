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

extension Int {
    
    func formatted(maxFractionDigits: Int = 1, minimumFractionDigits: Int = 0) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maxFractionDigits
        formatter.minimumFractionDigits = minimumFractionDigits
        return formatter.string(for: self) ?? ""
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler:nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

