//
//  RBSignatureViewController.swift
//  RoboBetty
//
//  Created by Ryan Khalili on 2/25/15.
//  Copyright (c) 2015 CSE112-GoldTeam. All rights reserved.
//

import UIKit

class RBSignatureViewController: UIViewController
{
    @IBOutlet weak var centerBackground: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    
    var keyboardVisible = false
    
    var appointmentID: String?
    
    var progressHud: M13ProgressHUD!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        backButton.layer.borderColor = UIColor.whiteColor().CGColor
        backButton.layer.borderWidth = 1
        
        submitButton.layer.borderColor = UIColor.whiteColor().CGColor
        submitButton.layer.borderWidth = 1
        
        let progressRing = M13ProgressViewRing()
        progressRing.indeterminate = true
        progressHud = M13ProgressHUD( progressView: progressRing )
        progressHud.progressViewSize = CGSizeMake( 100, 100 )
        progressHud.animationPoint = CGPointMake( UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2 );
    }
    
    override func viewWillAppear( animated: Bool )
    {
        super.viewWillAppear( animated )
        
        ( self.navigationController as? RBNavigationController )?.progressBar.setCurrentStep( 4, animated: true )

        NSNotificationCenter.defaultCenter().addObserver( self, selector: "didReceiveKeyboardNotification:", name: UIKeyboardWillHideNotification, object: nil )
        NSNotificationCenter.defaultCenter().addObserver( self, selector: "didReceiveKeyboardNotification:", name: UIKeyboardWillShowNotification, object: nil )
    }
    
    override func viewWillDisappear( animated: Bool )
    {
        super.viewWillDisappear( animated )
        NSNotificationCenter.defaultCenter().removeObserver( self )
    }
    
    @objc func didReceiveKeyboardNotification( notification: NSNotification )
    {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = ( info[UIKeyboardFrameEndUserInfoKey] as NSValue ).CGRectValue()
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as Double
        let curve = info[UIKeyboardAnimationCurveUserInfoKey] as UInt
        let options = UIViewAnimationOptions( curve << 16 )
        
        if notification.name == UIKeyboardWillShowNotification
        {
            let keyboardY = keyboardFrame.origin.y
            let difference = ( 172.0 + centerBackground.frame.size.height ) - keyboardY
            
            centerConstraint.constant = difference + 40
            ( self.navigationController as? RBNavigationController )?.hideProgressBar( true )
            
            keyboardVisible = true
        }
        else
        {
            centerConstraint.constant = 20
            ( self.navigationController as? RBNavigationController )?.showProgressBar( true )
            
            keyboardVisible = false
        }
        
        UIView.animateWithDuration( duration, delay: 0, options: options, animations:
        {
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded()
        },
        completion: nil )
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        super.touchesBegan( touches, withEvent: event )
        view.endEditing( true )
    }
    
    @IBAction func backButtonPressed()
    {
        navigationController?.popViewControllerAnimated( true )
    }
    
    @IBAction func submitButtonPressed()
    {
        view.endEditing( true )
        let delegate = UIApplication.sharedApplication().delegate? as AppDelegate
        delegate.window?.addSubview( progressHud )
        progressHud.status = "Checking You In..."
        progressHud.indeterminate = true
        progressHud.show( true )
        
        RBAPIManager.manager.sendSignature( "Bullshit", forAppointmentID: appointmentID!, completion:
        {
            success in
            
            self.progressHud.hide( true )
            self.performSegueWithIdentifier( "thankYou", sender: nil )
        })
    }
}