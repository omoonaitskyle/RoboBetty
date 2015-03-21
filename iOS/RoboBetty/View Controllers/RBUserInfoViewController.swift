//
//  UserInfoViewController.swift
//  RoboBetty 
//
//  Created by Mike Griffin on 2/9/15.
//  Copyright (c) 2015 CSE112-GoldTeam. All rights reserved.
//

import UIKit

class RBUserInfoViewController: UIViewController, UINavigationBarDelegate
{
    @IBOutlet weak var nextSignInButton: UIButton!
    @IBOutlet weak var notYouButton: UIButton!
    @IBOutlet var hiLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet weak var appointmentLabel: UILabel!
    
    var progressHud: M13ProgressHUD!
    
    var firstName:NSString!
    var lastName:NSString!
    var dateOfBirth:NSString!
    var email:NSString!
    var appointmentTime:NSString!
    var information:NSDictionary!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nextSignInButton.backgroundColor = UIColor.grayColor()
        nextSignInButton.layer.borderColor = UIColor.whiteColor().CGColor
        nextSignInButton.layer.borderWidth = 1
        
        notYouButton.backgroundColor = UIColor.redColor()
        notYouButton.layer.borderColor = UIColor.whiteColor().CGColor
        notYouButton.layer.borderWidth = 1
        
        firstName = information.valueForKey("fname") as NSString
        lastName = information.valueForKey("lname") as NSString
        dateOfBirth = information.valueForKey("dob") as NSString
        email = information.valueForKey("email") as NSString
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let date = information.valueForKey("date") as NSDate
        appointmentTime = dateFormatter.stringFromDate(date)
        
        hiLabel.text = "Hi, " + firstName
        nameLabel.text = firstName + " " + lastName
        dobLabel.text = dateOfBirth
        emailLabel.text = email
        appointmentLabel.text = "Appointment Time: \(appointmentTime)"
        
        let progressRing = M13ProgressViewRing()
        progressRing.indeterminate = true
        progressHud = M13ProgressHUD( progressView: progressRing )
        progressHud.progressViewSize = CGSizeMake( 100, 100 )
        progressHud.animationPoint = CGPointMake( UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2 );
    }
    
    override func viewWillAppear( animated: Bool )
    {
        super.viewWillAppear( animated )
        
        ( self.navigationController as? RBNavigationController )?.progressBar.setCurrentStep( 2, animated: true )
    }
    
    @IBAction func nextButtonPressed()
    {
        let delegate = UIApplication.sharedApplication().delegate? as AppDelegate
        delegate.window?.addSubview( progressHud )
        progressHud.status = "Getting your forms..."
        progressHud.show( true )
        progressHud.indeterminate = true
        
        RBAPIManager.manager.getCustomForms()
        {
            responseObject in
            self.performSegueWithIdentifier( "moreInfo", sender: responseObject )
            self.progressHud.hide( true )
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "moreInfo"
        {
            let dest = segue.destinationViewController as RBAdditionalInfoViewController
            dest.appointmentID = ( sender as? NSDictionary )?.objectForKey( "_id" ) as? String
            dest.formFields = ( sender as? NSDictionary )?.objectForKey("fields") as? NSArray
        }
    }
    
    override func viewWillDisappear( animated: Bool )
    {
        super.viewWillDisappear( animated )
    }
    
    @IBAction func notYouButtonPressed()
    {
        navigationController?.popViewControllerAnimated( true )
    }
}