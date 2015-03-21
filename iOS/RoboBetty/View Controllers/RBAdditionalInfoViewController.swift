//
//  RBAdditionalInfoViewController.swift
//  RoboBetty
//
//  Created by Ryan Khalili on 2/25/15.
//  Copyright (c) 2015 CSE112-GoldTeam. All rights reserved.
//

import UIKit

class RBAdditionalInfoViewController: UIViewController
{
    @IBOutlet weak var formScrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var doneToolbar: UIToolbar!
    
    private var manager = RBAPIManager()
    var formFields: NSArray?
    
    var appointmentID: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        doneToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        var space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var done =  UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneWithKeyboard"))
        doneToolbar.items = [space, done]
        doneToolbar.sizeToFit()
        
        setupScrollViewForm()
        
        nextButton.backgroundColor = UIColor.grayColor()
        nextButton.layer.masksToBounds = true
        nextButton.layer.borderColor = UIColor.whiteColor().CGColor
        nextButton.layer.borderWidth = 1
        
        backButton.layer.masksToBounds = true
        backButton.layer.borderColor = UIColor.whiteColor().CGColor
        backButton.layer.borderWidth = 1
    }
    
    @objc func doneWithKeyboard()
    {
        view.endEditing(true)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        view.endEditing(true)
    }
    
    override func viewWillAppear( animated: Bool )
    {
        super.viewWillAppear( animated )
        
        ( self.navigationController as? RBNavigationController )?.progressBar.setCurrentStep( 3, animated: true )
    }
    
    @IBAction func backButtonPressed()
    {
        navigationController?.popViewControllerAnimated( true )
    }
    
    
    @IBAction func nextButtonPressed()
    {
        performSegueWithIdentifier( "signature", sender: nil )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "signature"
        {
            let dest = segue.destinationViewController as RBSignatureViewController
            dest.appointmentID = appointmentID
        }
    }
    
    private func setupScrollViewForm()
    {
        formScrollView.backgroundColor = UIColor( red: 0, green: 0, blue: 0, alpha: 0.4 )
        
        let separationSpace = 12.0 as CGFloat
        var runningSize = separationSpace
        
        let detailLabel = UILabel()
        detailLabel.text = "Tell us a little bit more about yourself:"
        detailLabel.textColor = UIColor.whiteColor()
        detailLabel.font = RBConstants.primaryFont( 22.0 )
        detailLabel.sizeToFit()
        detailLabel.frame = CGRectMake( 18, 15, detailLabel.frame.size.width, detailLabel.frame.size.height )
        formScrollView.addSubview( detailLabel )
        
        runningSize += detailLabel.frame.size.height + separationSpace + 10
                
        for form in formFields as Array<NSDictionary>
        {
            if form["type"] as String == "textfield"
            {
                let textField = RBTextField()
                textField.backgroundColor = UIColor.whiteColor()
                textField.borderStyle = UITextBorderStyle.None
                textField.font = RBConstants.primaryFont( 16.0 )
                textField.placeholder = form["label"] as? String
                textField.frame = CGRectMake( 15, runningSize, 550, 30 )
                textField.inputAccessoryView = doneToolbar
                formScrollView.addSubview( textField )
                
                runningSize += 30 + separationSpace
            }
            else if form["type"] as String == "dropdown"
            {
                let choices = form["options"] as [String]
                let segmentedControl = UISegmentedControl( items: choices )
                segmentedControl.tintColor = UIColor.whiteColor()
                let attributes = [ NSFontAttributeName : RBConstants.primaryFont( 15.0 ) ]
                segmentedControl.setTitleTextAttributes( attributes, forState: UIControlState.Normal )
                segmentedControl.sizeToFit()
                segmentedControl.frame = CGRectMake( 15, runningSize, 550, segmentedControl.frame.size.height )
                segmentedControl.selectedSegmentIndex = 0
                formScrollView.addSubview( segmentedControl )
                
                runningSize += 30 + separationSpace
            }
        }
        
        formScrollView.contentSize.height = runningSize
    }
}