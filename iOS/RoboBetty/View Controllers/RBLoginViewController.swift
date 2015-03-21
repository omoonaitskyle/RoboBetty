//
//  RBLoginViewController.swift
//  RoboBetty
//
//  Created by Ryan Khalili on 2/10/15.
//  Copyright (c) 2015 CSE112-GoldTeam. All rights reserved.
//

import UIKit

class RBLoginViewController: UIViewController
{
    private(set) var backgroundImageView: UIImageView!
    private(set) var robotImageView: UIImageView!
    private(set) var logoImage: UIImageView!
    private(set) var formBackgroundView: UIView!
    private(set) var usernameField: RBTextField!
    private(set) var passwordField: RBTextField!
    private(set) var loginButton: UIButton!
    
    private(set) var progressHud: M13ProgressHUD!
    
    private var centerConstraint: NSLayoutConstraint!
    
    private var shouldSplash = false
    
    init( splash: Bool )
    {
        super.init( nibName: nil, bundle: nil )
        shouldSplash = splash
    }
    
    required init( coder aDecoder: NSCoder)
    {
        super.init( coder: aDecoder )
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loginButton.addTarget( self, action: "submitLogin", forControlEvents: UIControlEvents.TouchUpInside )
    }
    
    override func touchesBegan( touches: NSSet, withEvent event: UIEvent )
    {
        super.touchesBegan( touches, withEvent: event )
        view.endEditing( true )
    }
    
    override func viewWillAppear( animated: Bool )
    {
        super.viewWillAppear( animated )
        
        NSNotificationCenter.defaultCenter().addObserver( self, selector: "didReceiveKeyboardNotification:", name: UIKeyboardWillHideNotification, object: nil )
        NSNotificationCenter.defaultCenter().addObserver( self, selector: "didReceiveKeyboardNotification:", name: UIKeyboardWillShowNotification, object: nil )
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
            let difference = ( formBackgroundView.frame.origin.y + formBackgroundView.frame.size.height ) - keyboardY
            
            centerConstraint.constant = -( difference + 10 )
            ( self.navigationController as? RBNavigationController )?.hideProgressBar( true )
        }
        else
        {
            centerConstraint.constant = 0
            ( self.navigationController as? RBNavigationController )?.showProgressBar( true )
        }
        
        UIView.animateWithDuration( duration, delay: 0, options: options, animations:
        {
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded()
        },
        completion: nil )
    }
    
    override func viewDidAppear( animated: Bool )
    {
        super.viewDidAppear( animated )
        
        UIView.animateWithDuration( 1.0, delay: 1.0, options: nil, animations:
        {
            self.setupLoginLayout()
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded()
        },
        completion: nil )
    }
    
    func submitLogin()
    {
        let delegate = UIApplication.sharedApplication().delegate? as AppDelegate
        delegate.window?.addSubview( progressHud )
        progressHud.status = "Logging In..."
        progressHud.show( true )
        progressHud.indeterminate = true
        view.endEditing( true )
        
        RBAPIManager.manager.login( usernameField.text, password: passwordField.text )
        {
            success in
            
            self.progressHud.hide( true )
            
            if success
            {
                ( UIApplication.sharedApplication().delegate as AppDelegate ).appLoggedIn()
            }
        }
    }
    
    override func loadView()
    {
        view = UIView()
        setupInitialLayout()
        
        if shouldSplash != true
        {
            setupLoginLayout()
        }
    }
    
    private func setupInitialLayout()
    {
        backgroundImageView = UIImageView( image: UIImage( named: "background" ) )
        view.addSubview( backgroundImageView )
        backgroundImageView.autoPinEdgesToSuperviewEdgesWithInsets( UIEdgeInsetsZero )
        
        let robotImage = UIImage( named: "robot" )
        robotImageView = UIImageView( image: robotImage )
        robotImageView.contentMode = UIViewContentMode.ScaleAspectFit
        robotImageView.hidden = true
        view.addSubview( robotImageView )
        robotImageView.autoCenterInSuperview()
        robotImageView.autoSetDimensionsToSize( CGSizeMake( robotImage!.size.width * 0.80, robotImage!.size.height * 0.8 ) )
        
        createLoginViews()
    }
    
    private func createLoginViews()
    {
        let image = UIImage( named: "whitelogo" )
        logoImage = UIImageView()
        logoImage.image = image
        logoImage.frame = CGRectMake( 0, 0, image!.size.width, image!.size.height )
        
        formBackgroundView = UIView()
        formBackgroundView.backgroundColor = UIColor( red: 0, green: 0, blue: 0, alpha: 0.7 )
        
        let signInLabel = UILabel()
        signInLabel.font = RBConstants.primaryFont( 18.0 )
        signInLabel.textColor = UIColor.whiteColor()
        signInLabel.text = "Sign In"
        signInLabel.sizeToFit()
        formBackgroundView.addSubview( signInLabel )
        signInLabel.autoSetDimensionsToSize( signInLabel.frame.size )
        signInLabel.autoPinEdgeToSuperviewEdge( ALEdge.Top, withInset: 10 )
        signInLabel.autoPinEdgeToSuperviewEdge( ALEdge.Left, withInset: 15 )
        
        usernameField = RBTextField()
        usernameField.font = RBConstants.primaryFont( 18.0 )
        usernameField.placeholder = "Username / Email"
        usernameField.textColor = UIColor.blackColor()
        usernameField.backgroundColor = UIColor.whiteColor()
        usernameField.autocorrectionType = UITextAutocorrectionType.No
        formBackgroundView.addSubview( usernameField )
        usernameField.autoPinEdge( ALEdge.Top, toEdge: ALEdge.Bottom, ofView: signInLabel, withOffset: 10.0 )
        usernameField.autoPinEdgeToSuperviewEdge( ALEdge.Left, withInset: 15.0 )
        usernameField.autoPinEdgeToSuperviewEdge( ALEdge.Right, withInset: 15.0 )
        usernameField.autoSetDimension( ALDimension.Height, toSize: 40.0 )
        
        passwordField = RBTextField()
        passwordField.secureTextEntry = true
        passwordField.font = RBConstants.primaryFont( 18.0 )
        passwordField.placeholder = "Password"
        passwordField.textColor = UIColor.blackColor()
        passwordField.backgroundColor = UIColor.whiteColor()
        formBackgroundView.addSubview( passwordField )
        passwordField.autoPinEdge( ALEdge.Top, toEdge: ALEdge.Bottom, ofView: usernameField, withOffset: 10.0 )
        passwordField.autoPinEdge( ALEdge.Left, toEdge: ALEdge.Left, ofView: usernameField )
        passwordField.autoPinEdge( ALEdge.Right, toEdge: ALEdge.Right, ofView: usernameField )
        passwordField.autoMatchDimension( ALDimension.Height, toDimension: ALDimension.Height, ofView: usernameField )
        
        loginButton = UIButton.buttonWithType( UIButtonType.Custom ) as UIButton
        loginButton.setTitle( "Submit", forState: UIControlState.Normal )
        loginButton.titleLabel?.font = RBConstants.primaryFont( 20.0 )
        loginButton.setTitleColor( UIColor.whiteColor(), forState: UIControlState.Normal )
        loginButton.backgroundColor = UIColor.grayColor()
        loginButton.showsTouchWhenHighlighted = true
        loginButton.sizeToFit()
        formBackgroundView.addSubview( loginButton )
        loginButton.autoPinEdge( ALEdge.Top, toEdge: ALEdge.Bottom, ofView: passwordField, withOffset: 20 )
        loginButton.autoPinEdgeToSuperviewEdge( ALEdge.Bottom, withInset: 20.0 )
        loginButton.autoPinEdge( ALEdge.Left, toEdge: ALEdge.Left, ofView: passwordField )
        loginButton.autoPinEdge( ALEdge.Right, toEdge: ALEdge.Right, ofView: passwordField )
        
        logoImage.alpha = 0
        view.addSubview( logoImage )
        logoImage.autoSetDimensionsToSize( logoImage.frame.size )
        logoImage.autoAlignAxisToSuperviewAxis( ALAxis.Vertical )
        
        formBackgroundView.alpha = 0
        view.addSubview( formBackgroundView )
        formBackgroundView.autoMatchDimension( ALDimension.Height, toDimension: ALDimension.Height, ofView: robotImageView )
        formBackgroundView.autoAlignAxisToSuperviewAxis( ALAxis.Vertical )
        centerConstraint = formBackgroundView.autoAlignAxisToSuperviewAxis( ALAxis.Horizontal )
//        formBackgroundView.autoCenterInSuperview()
        formBackgroundView.autoMatchDimension( ALDimension.Width, toDimension: ALDimension.Width, ofView: logoImage, withMultiplier: 1.50 )
        
        logoImage.autoPinEdge( ALEdge.Bottom, toEdge: ALEdge.Top, ofView: formBackgroundView, withOffset: -10.0 )
        
        let progressRing = M13ProgressViewRing()
        progressRing.indeterminate = true
        progressHud = M13ProgressHUD( progressView: progressRing )
        progressHud.progressViewSize = CGSizeMake( 100, 100 )
        progressHud.animationPoint = CGPointMake( UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2 );
    }
    
    private func setupLoginLayout()
    {
        robotImageView.removeFromSuperview()
        view.addSubview( robotImageView )
        
        robotImageView.autoPinEdge( ALEdge.Right, toEdge: ALEdge.Left, ofView: formBackgroundView, withOffset: -20.0 )
        robotImageView.autoPinEdge( ALEdge.Top, toEdge: ALEdge.Top, ofView: formBackgroundView )
        
        logoImage.alpha = 1
        formBackgroundView.alpha = 1
    }
}