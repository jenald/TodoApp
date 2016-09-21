//
//  MLPendingTableViewCell.swift
//  TodoAppML
//
//  Created by Rey Pena on 20/09/2016.
//  Copyright © 2016 Malaysia. All rights reserved.
//

import UIKit
import Foundation

class MLPendingTableViewCell: UITableViewCell {
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    var data : AnyObject!
    
    let DEFAULT_COUNT = Int(5)
    
    weak var delegate : MLPendingTableViewCellDelegate?
    
    private var timer : NSTimer!
    private var countDown : Int = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Private Functions
    
    func updateCounter() {
        self.countDown = self.countDown - 1
        if self.countDown == 0 {
            if let delegate = self.delegate {
                self.countDown = DEFAULT_COUNT
                self.startCancelAnimation(false)
                delegate.pendingCellDidFinishCount(self)
                self.timer.invalidate()
            }
        }
    }
    
    func startCancelAnimation(start : Bool) {
        
        if start {
            let pulseAnimation = CABasicAnimation(keyPath: "opacity")
            pulseAnimation.duration = 1
            pulseAnimation.fromValue = 0.5
            pulseAnimation.toValue = 1
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = FLT_MAX
            self.cancelButton.layer.backgroundColor = UIColor.redColor().CGColor
            self.cancelButton.layer.cornerRadius = 3
            self.cancelButton.layer.addAnimation(pulseAnimation, forKey: "animateOpacity")
        } else {
            self.cancelButton.hidden = true
            self.timer.invalidate()
            self.countDown = DEFAULT_COUNT
            self.cancelButton.layer.removeAllAnimations()
        }
    }
    
    // MARK: Pubic Functions
    
    func animateCancelButton() {
        
        self.cancelButton.hidden = !self.cancelButton.hidden
        
        if self.cancelButton.hidden {
            self.timer.invalidate()
            self.startCancelAnimation(false)
        } else {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            self.startCancelAnimation(true)
        }
    }
    
    // MARK: IBActions

    @IBAction func didTapCancelButton(sender: AnyObject) {
        self.countDown = DEFAULT_COUNT
        if let delegate = self.delegate {
            delegate.pendingCellDidCancelOperation(self)
        }
    }
}

@objc protocol MLPendingTableViewCellDelegate : class {
    func pendingCellDidFinishCount(cell : MLPendingTableViewCell)
    func pendingCellDidCancelOperation(cell : MLPendingTableViewCell)
}
