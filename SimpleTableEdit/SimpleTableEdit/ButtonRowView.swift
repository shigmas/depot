//
//  ButtonRowView.swift
//  SimpleTableEdit
//
//  Created by Masa Jow on 10/13/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

import UIKit
import CoreGraphics

let ButtonRowView_CompletionChosenNotification = "CompletionChosenNotification"
let ButtonRowView_CompletionKey = "completion"


// A row of buttons
//
class ButtonRowView: UIView {

    let MaxWidth: CGFloat = 960.0 // you could argue this is already too big for scrolling.  At least on the iPhone.  So, maybe, this should rely on a passed in frame.
    let Margin: CGFloat = 2.0

    var _height : CGFloat = 30.0

    private var _buttons : Array<UIButton> = []
    private var _titleMap : Dictionary<String, String> = [:]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Preferred initializer, so we know how wide we are.
    override init(frame: CGRect) {
        super.init(frame: frame)
        _height = frame.height
        backgroundColor = UIColor.lightGrayColor()
        alpha = 0.8
    }

    func _getParentScrollView() -> UIScrollView {
        var parent = superview as? UIScrollView

        if parent == nil {
            parent = UIScrollView()
        }
        
        return parent!
    }

    func _createButton(title: String) {
        var but = UIButton.buttonWithType(.System) as UIButton
        but.setTitle(title, forState: .Normal)
        but.titleLabel?.font = UIFont.systemFontOfSize(12)
        but.addTarget(self, action: "_buttonPressed:",
            forControlEvents: .TouchDown)
        addSubview(but)
    }

    func addButtons(buttonValues: Dictionary<String,String>) {
        _titleMap = buttonValues
        for title in buttonValues.keys {
            println("Adding button with \(title)")
            _createButton(title)
        }
    }

    func _buttonPressed(button: UIButton) {
        let key = button.titleLabel?.text
        if key != nil {
            let completion: String = _titleMap[key!]!
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(ButtonRowView_CompletionChosenNotification, object: self, userInfo: [ButtonRowView_CompletionKey:completion])
        }
    }

    func _getFontToFit(currentFont: UIFont?, height: CGFloat, margin: CGFloat) -> UIFont? {
        if currentFont != nil {
            let maxFontHeight = height - margin * 2
            var newFont = UIFont(name: currentFont!.fontName, size: 24)
            // Set the font to be really big, and start shrinking
            
            while newFont.capHeight > maxFontHeight {
                let newSize = newFont.pointSize - 2
                newFont = UIFont(name: newFont.fontName, size: newSize)
            }
            return newFont
        }
        return nil
    }

    // gets a frame for the text and the font, starting with the origin.
    func _getTextFrame(origin: CGPoint, text: String?, font: UIFont?) -> CGRect {
        // The font has already been computed to fit the global height, but
        // we still need to provide the height for the bounding box.
        var textFrame = CGRect()
        if text != nil || font != nil {
            let textTmp = text!
            let fontTmp = font!
            let bounds = CGSize(width: MaxWidth-origin.x, height: _height)
            textFrame = (textTmp as NSString).boundingRectWithSize(bounds,
                options: NSStringDrawingOptions.UsesFontLeading,
                attributes: [NSFontAttributeName:fontTmp],
                context:nil)
            textFrame.origin = origin
        }
        return textFrame
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // We will get the frames for all the buttons and use that to create
        // the frame for the containerView.  Then, the scrollview can pan
        // around that.
        var origin = frame.origin
        let button = subviews.first as? UIButton
        let sizedFont = _getFontToFit(button?.titleLabel?.font, height: _height, margin: Margin)
        for view in subviews {
            if let button = view as? UIButton {
                let label = button.titleLabel
                println("origin: \(origin)")
                let buttonFrame = _getTextFrame(origin, text:label?.text, font:label?.font)
                let t = label?.text!
                println("\(t) rect: \(buttonFrame)")
                button.frame = buttonFrame
                origin.x += buttonFrame.width
            }
        }
        // The last origin.x hasnt been used, but it's our final width.
        let size = CGSize(width: origin.x, height: _height)
        let scrollView = _getParentScrollView()
        scrollView.contentSize = size
        frame = CGRect(origin: CGPoint(x: 0,y: 0), size: size)
        
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Draw the buttons, etc.
        super.drawRect(rect)

        // Drawing code - draw vertical lines between the button splits
        var context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0);
        CGContextSetLineCap(context, kCGLineCapRound);

        for view in subviews {
            // Get the rects, and we'll draw at the origins
            let f = view.frame
            CGContextMoveToPoint(context,f.origin.x, f.origin.y)
            CGContextAddLineToPoint(context, f.origin.x, f.origin.y+_height)
            CGContextStrokePath(context)
        }
    }
}
