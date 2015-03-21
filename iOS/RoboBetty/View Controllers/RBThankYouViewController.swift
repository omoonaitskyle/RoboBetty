//
//  ThankYouViewController.swift
//  RoboBetty
//
//  Created by Brian Fong on 2/9/15.
//  Copyright (c) 2015 CSE112-GoldTeam. All rights reserved.
//

import UIKit

class RBThankYouViewController: UIViewController
{
    @IBOutlet var okButton: UIButton!
    @IBOutlet var pic: UIImageView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    
    var previous: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ( self.navigationController as? RBNavigationController )?.hideStartOverButton()
        
        okButton.backgroundColor = UIColor.grayColor()
        okButton.layer.borderColor = UIColor.whiteColor().CGColor
        okButton.layer.borderWidth = 1
        pic.image = UIImage(named: "gold-wreath-md.png")
        
        if previous == "No Appointment"
        {
            topLabel.text = "Please wait, someone will be with you shortly."
            okButton.setTitle( "Okay", forState: UIControlState.Normal )
        }
    }

    @IBAction func doneButtonPressed()
    {
        navigationController?.popToRootViewControllerAnimated( true )
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear( animated )
        
        if ( self.navigationController as? RBNavigationController )?.isProgressBarVisible() == true
        {
            ( self.navigationController as? RBNavigationController )?.progressBar.setCurrentStep( 5, animated: true )
        }
    }
}