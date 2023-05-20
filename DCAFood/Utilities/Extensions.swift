//
//  Extensions.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import Foundation
import UIKit

extension UIImageView {
    static func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

extension UILabel {
    static func createLabel(fontName: String = "HelveticaNeue", fontSize: CGFloat = 14, color: UIColor? = .black) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: fontName, size: fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = color
        return label
    }
}

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        for subview in subviews {
            addSubview(subview)
        }
    }
}

extension UIImageView {
    private struct AssociatedKeys {
        static var imageURL = "imageURL"
    }
    
    var imageURL: URL? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.imageURL) as? URL
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.imageURL, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
