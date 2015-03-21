//
//  RBConstants.swift
//  RoboBetty
//
//  Created by Ryan Khalili on 2/10/15.
//  Copyright (c) 2015 CSE112-GoldTeam. All rights reserved.
//

import Foundation

struct RBConstants
{
    static func primaryFont( size: CGFloat ) -> UIFont
    {
        return UIFont( name: "Futura-Medium", size: size )!
    }
    
    static func logoStringWithSize( size: CGFloat ) -> NSAttributedString
    {
        let futura = UIFont( name: "Futura-Medium", size: size - 5 )
        let oleo = UIFont( name: "OleoScript-Regular", size: size )
        
        let roboAttributes = [NSFontAttributeName:futura!]
        let robo = NSMutableAttributedString( string: "Robo", attributes: roboAttributes )
        
        let bettyAttributes = [NSFontAttributeName:oleo!]
        let betty = NSAttributedString( string: "Betty", attributes: bettyAttributes )
        
        robo.appendAttributedString( betty )
        
        return robo
    }
}