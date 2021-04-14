//
//  RoundButton.swift
//  NIBM-FoodOrdering
//
//  Created by user189391 on 4/14/21.
//

import UIKit

@IBDesignable class RoundedImage: UIImageView
{
    override func layoutSubviews() {
        super.layoutSubviews()

        updateCornerRadius()
    }

    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.1 {
        didSet {
            updateCornerRadius()
        }
    }

    func updateCornerRadius() {
        layer.cornerRadius = rounded ? cornerRadius : 0
        layer.masksToBounds = rounded ? true : false
    }
}

@IBDesignable class RoundedView: UIView
{
    override func layoutSubviews() {
        super.layoutSubviews()

        updateCornerRadius()
    }

    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.1 {
        didSet {
            updateCornerRadius()
        }
    }

    func updateCornerRadius() {
        layer.cornerRadius = rounded ? cornerRadius : 0
        layer.masksToBounds = rounded ? true : false
    }
}

@IBDesignable class RoundedButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()

        updateCornerRadius()
    }

    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.1 {
        didSet {
            updateCornerRadius()
        }
    }

    func updateCornerRadius() {
        layer.cornerRadius = rounded ? cornerRadius : 10
        layer.masksToBounds = rounded ? true : false
    }
}
