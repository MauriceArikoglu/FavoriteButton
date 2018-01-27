//
//  FavoriteButton.swift
//  FavoriteButton
//
// Copyright © 2016 Jansel Valentin, Copyright © 2018 Maurice Arikoglu
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public typealias DotColors = (first: UIColor, second: UIColor)

@available(iOS 10.0, *)
public protocol FavoriteButtonDelegate {

    func favoriteButton(_ faveButton: FavoriteButton, didSelect selected: Bool)
    func favoriteButtonDotColors(_ faveButton: FavoriteButton) -> [DotColors]?

}

// MARK: Default implementation
@available(iOS 10.0, *)
public extension FavoriteButtonDelegate {

    func favoriteButtonDotColors(_ faveButton: FavoriteButton) -> [DotColors]? { return nil }

}

@available(iOS 10.0, *)
open class FavoriteButton: UIButton {

    fileprivate struct Constants {

        static let duration             = 1.0
        static let expandDuration       = 0.1298
        static let collapseDuration     = 0.1089
        static let faveIconShowDelay    = Constants.expandDuration + Constants.collapseDuration/2.0
        static let dotRadiusFactors     = (first: 0.0633, second: 0.04)

    }

    // MARK: Colors
    @IBInspectable open var normalColor: UIColor = UIColor(red:   137.0.fromRGB,
                                                           green: 156.0.fromRGB,
                                                           blue:  167.0.fromRGB, alpha: 1.0) {
        didSet {
            if faveIcon != nil && !isSelected {
                faveIcon.iconLayer.fillColor = normalColor.cgColor
            }
        }
    }

    @IBInspectable open var selectedColor: UIColor = UIColor(red:   226.0.fromRGB,
                                                             green: 38.0.fromRGB,
                                                             blue:  77.0.fromRGB, alpha: 1.0) {
        didSet {
            if faveIcon != nil && isSelected {
                faveIcon.iconLayer.fillColor = selectedColor.cgColor
            }
        }
    }

    @IBInspectable open var dotFirstColor: UIColor = UIColor(red:   152.0.fromRGB,
                                                             green: 219.0.fromRGB,
                                                             blue:  236.0.fromRGB, alpha: 1.0)

    @IBInspectable open var dotSecondColor: UIColor = UIColor(red:   247.0.fromRGB,
                                                              green: 188.0.fromRGB,
                                                              blue:  48.0.fromRGB, alpha: 1.0)

    @IBInspectable open var circleFromColor: UIColor = UIColor(red:   221.0.fromRGB,
                                                               green: 70.0.fromRGB,
                                                               blue:  136.0.fromRGB, alpha: 1.0)

    @IBInspectable open var circleToColor: UIColor = UIColor(red:   205.0.fromRGB,
                                                             green: 143.0.fromRGB,
                                                             blue:  246.0.fromRGB, alpha: 1.0)

    // MARK: Delegate
    @IBOutlet open weak var delegate: AnyObject?

    fileprivate(set) var sparkGroupCount: Int = 7

    fileprivate var faveIconImage: UIImage?
    fileprivate var faveIcon: FaveIcon!

    var faveId: Any?
    
    var providesHapticFeedback: Bool = true
    var selectionFeedback: UISelectionFeedbackGenerator = {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        return generator
    }()

    override open var isSelected: Bool {
        didSet {
            animateSelect(isSelected, duration: Constants.duration)
        }
    }

    convenience public init(frame: CGRect, faveIconNormal: UIImage?) {
        self.init(frame: frame)

        guard let icon = faveIconNormal else {
            fatalError("missing image for normal state")
        }

        faveIconImage = icon

        applyInit()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyInit()
    }

}

// MARK: create
@available(iOS 10.0, *)
extension FavoriteButton {

    fileprivate func applyInit() {

        if nil == faveIconImage {
            faveIconImage = image(for: UIControlState())
        }

        guard let faveIconImage = faveIconImage else {
            fatalError("please provide an image for normal state.")
        }

        setImage(UIImage(), for: UIControlState())
        setImage(UIImage(), for: .selected)
        setTitle(nil, for: UIControlState())
        setTitle(nil, for: .selected)

        faveIcon  = createFaveIcon(faveIconImage)

        addActions()
    }

    fileprivate func createFaveIcon(_ faveIconImage: UIImage) -> FaveIcon {
        return FaveIcon.createFaveIcon(self, icon: faveIconImage, color: normalColor)
    }

    fileprivate func createSparks(_ radius: CGFloat) -> [Spark] {
        var sparks    = [Spark]()
        let step      = 360.0/Double(sparkGroupCount)
        let base      = Double(bounds.size.width)
        let dotRadius = (base * Constants.dotRadiusFactors.first, base * Constants.dotRadiusFactors.second)
        let offset    = 10.0

        for index in 0..<sparkGroupCount {
            let theta  = step * Double(index) + offset
            let colors = dotColors(atIndex: index)

            let spark = Spark.createSpark(self, radius: radius, firstColor: colors.first, secondColor: colors.second, angle: theta, dotRadius: dotRadius)

            sparks.append(spark)
        }
        return sparks
    }

}

// MARK: Utility
@available(iOS 10.0, *)
extension FavoriteButton {

    fileprivate func dotColors(atIndex index: Int) -> DotColors {
        if case let delegate as FavoriteButtonDelegate = delegate, nil != delegate.favoriteButtonDotColors(self) {
            let colors     = delegate.favoriteButtonDotColors(self)!
            let colorIndex = 0..<colors.count ~= index ? index : index % colors.count

            return colors[colorIndex]
        }
        return DotColors(dotFirstColor, dotSecondColor)
    }

}

// MARK: Actions
@available(iOS 10.0, *)
extension FavoriteButton {
    
    func addActions() {
        self.addTarget(self, action: #selector(toggle(_:)), for: .touchUpInside)
    }

    @objc func toggle(_ sender: FavoriteButton) {
        
        selectionFeedback.prepare()

        sender.isSelected = !sender.isSelected

        if providesHapticFeedback {
            selectionFeedback.selectionChanged()
        }
        
        guard case let delegate as FavoriteButtonDelegate = delegate else {
            return
        }

        let delay = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * Constants.duration)) / Double(NSEC_PER_SEC)

        DispatchQueue.main.asyncAfter(deadline: delay) {
            delegate.favoriteButton(sender, didSelect: sender.isSelected)
        }
    }

}

// MARK: Animation
@available(iOS 10.0, *)
extension FavoriteButton {

    fileprivate func animateSelect(_ isSelected: Bool, duration: Double) {
        let color  = isSelected ? selectedColor : normalColor

        faveIcon.animateSelect(isSelected, fillColor: color, duration: duration, delay: Constants.faveIconShowDelay)

        if isSelected {
            let radius = bounds.size.scaleBy(1.3).width / 2 // ring radius
            let igniteFromRadius = radius * 0.8
            let igniteToRadius = radius * 1.1

            let ring = Ring.createRing(self, radius: 0.01, lineWidth: 3, fillColor: circleFromColor)
            let sparks = createSparks(igniteFromRadius)

            ring.animateToRadius(radius, toColor: circleToColor, duration: Constants.expandDuration, delay: 0)
            ring.animateColapse(radius, duration: Constants.collapseDuration, delay: Constants.expandDuration)

            sparks.forEach {
                $0.animateIgniteShow(igniteToRadius, duration:0.4, delay: Constants.collapseDuration/3.0)
                $0.animateIgniteHide(0.7, delay: 0.2)
            }
        }
    }

}

private extension Double {

    var fromRGB: CGFloat {
        return CGFloat(self / 255.0)
    }

}
