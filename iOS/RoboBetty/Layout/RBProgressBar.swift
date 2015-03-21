//
//  RBProgressBarViewController.swift
//  RoboBetty
//
//  Created by Brian Chin on 2/22/15.
//  Copyright (c) 2015 CSE112-GoldTeam. All rights reserved.
//

import UIKit

class RBProgressBar: UIView
{
    var numSteps = 5
    var currentStep = 1
    var outerBar: UIView!
    var progressBar: UIView!
    var ticks: [UIView]!
    
    private var progressConstraint: NSLayoutConstraint!
    
    init( numberOfSteps: Int )
    {
        super.init()
        numSteps = numberOfSteps
        setupViews( numberOfSteps )
    }
    
    override init( frame: CGRect )
    {
        super.init( frame: frame )
        setupViews( numSteps )
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init( coder: aDecoder )
        setupViews( numSteps )
    }
    
    private func setupViews( numberOfSteps: Int )
    {
        outerBar = UIView()
        outerBar.backgroundColor = UIColor.lightGrayColor()
        outerBar.layer.masksToBounds = true
        outerBar.layer.cornerRadius = 7.0
        addSubview( outerBar )
        outerBar.autoPinEdgesToSuperviewEdgesWithInsets( UIEdgeInsetsZero )
        
        ticks = [UIView]()
        
        var test = NSLayoutConstraint()
        
        for step in 1...numSteps - 1
        {
            let tickView = UIView()
            tickView.backgroundColor = UIColor.blackColor()
            addSubview( tickView )
            ticks.append( tickView )
        }
        
        progressBar = UIView()
        progressBar.backgroundColor = UIColor.blackColor()
        progressBar.layer.masksToBounds = true
        progressBar.layer.cornerRadius = 5.0
        addSubview( progressBar )
        progressBar.autoPinEdge( ALEdge.Left, toEdge: ALEdge.Left, ofView: outerBar, withOffset: 4 )
        progressBar.autoPinEdge( ALEdge.Top, toEdge: ALEdge.Top, ofView: outerBar, withOffset: 4 )
        progressBar.autoPinEdge( ALEdge.Bottom, toEdge: ALEdge.Bottom, ofView: outerBar, withOffset: -4 )
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        layoutTicks()
    }
    
    private func layoutTicks()
    {
        for index in 1...ticks.count
        {
            let tick = ticks[index - 1]
            let x = self.frame.size.width / CGFloat( numSteps ) * CGFloat( index )
            let height = self.frame.size.height
            let frame = CGRectMake( x, -3, 2, height + 6 )
            tick.frame = frame
        }
    }
    
    func setCurrentStep( current: Int, animated: Bool )
    {
        var step = current
        
        if progressConstraint != nil
        {
            removeConstraint( progressConstraint )
        }
        
        if current >= numSteps
        {
            currentStep = numSteps - 1
            progressConstraint = progressBar.autoPinEdge( ALEdge.Right, toEdge: ALEdge.Right, ofView: outerBar, withOffset: -4 )
        }
        else if current <= 0
        {
            currentStep = 0
        }
        else
        {
            currentStep = current
            progressConstraint = progressBar.autoPinEdge( ALEdge.Right, toEdge: ALEdge.Left, ofView: ticks[currentStep - 1], withOffset: 2 )
        }
        
        let duration = animated ? 0.5 : 0.0
        
        UIView.animateWithDuration( duration, animations:
        {
            self.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
        })
    }
    
    func setProgressBarColor( color: UIColor )
    {
        progressBar.backgroundColor = color
        
        for tick in ticks
        {
            tick.backgroundColor = color
        }
    }
}
