//
//  RBTextField.swift
//  RoboBetty
//
//  Created by Ryan Khalili on 2/10/15.
//  Copyright (c) 2015 CSE112-GoldTeam. All rights reserved.
//

import UIKit

class RBTextField: UITextField
{
    override func textRectForBounds( bounds: CGRect ) -> CGRect
    {
        return CGRectInset( bounds, 10, 0 )
    }
    
    override func editingRectForBounds( bounds: CGRect ) -> CGRect
    {
        return CGRectInset( bounds, 10, 0 )
    }
}