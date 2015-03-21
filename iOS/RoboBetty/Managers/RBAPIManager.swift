//
//  RBAPIManager.swift
//  RoboBetty
//
//  Created by Ryan Khalili on 2/10/15.
//  Copyright (c) 2015 CSE112-GoldTeam. All rights reserved.
//

public let RBAPILoggedInNotificationKey  = "RoboBetty Logged In"
public let RBAPILoggedOutNotificationKey = "RoboBetty Logged Out"

private let SharedManager = RBAPIManager()
private let baseURL = "http://robobetty-dev.herokuapp.com/api/m/"

import Foundation
import Alamofire

class RBAPIManager
{
    private var accessToken: String?
    
    class var manager: RBAPIManager
    {
        return SharedManager
    }
    
    init()
    {
        accessToken = NSUserDefaults.standardUserDefaults().objectForKey( "token" ) as? String
        
        if accessToken != nil
        {
            let authHeader = [ "Authorization": "Token " + accessToken! ]
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = authHeader
        }
    }
    
    private func saveAccessToken( token: String )
    {
        accessToken = token
        NSUserDefaults.standardUserDefaults().setObject( token, forKey: "token" )
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func isLoggedIn() -> Bool
    {
        return accessToken != nil
    }
    
    func login( username: String!, password: String!, completion: ( success: Bool ) -> () )
    {
        //accessToken = "temp"
        let url = "http://robobetty-dev.herokuapp.com/api/auth"
        
        let plainString = "\(username):\(password)" as NSString
        let plainData = plainString.dataUsingEncoding( NSUTF8StringEncoding )
        let base64String = plainData?.base64EncodedStringWithOptions( nil )
        
        let authHeader = [ "Authorization": "Basic " + base64String! ]
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = authHeader
        let parameters = [ "name": "Frodo" ]
        
        Alamofire.request( .POST, url, parameters: parameters ).response
        {
            request, response, data, error in
            
            if error == nil
            {
                let str = NSString( data: data as NSData, encoding: NSUTF8StringEncoding )
                
                if str == "Unauthorized"
                {
                    completion( success: false )
                }
                else
                {
                    let json = NSJSONSerialization.JSONObjectWithData( data as NSData, options: nil, error: nil ) as? NSDictionary
                    
                    if json == nil
                    {
                        completion( success: false )
                    }
                    else
                    {
                        let token = json!.objectForKey( "api_token" ) as String
                        self.saveAccessToken( token )
                        
                        let plainString = "\(token):" as NSString
                        let plainData = plainString.dataUsingEncoding( NSUTF8StringEncoding )
                        let base64String = plainData?.base64EncodedStringWithOptions( nil )
                        
                        let authHeader = [ "Authorization": "Token " + base64String! ]
                        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = authHeader
                        
                        completion( success: true )
                    }
                }
            }
            else
            {
                println( error )
                completion( success: false )
            }
        }
    }
    
    func logout()
    {
        accessToken = nil
        NSUserDefaults.standardUserDefaults().removeObjectForKey( "token" )
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getAppointmentInfo( fName: NSString, lName: NSString, dob: NSString, completionHandler: ( responseObject: NSMutableDictionary? ) -> () )
    {
        let url = baseURL + "appointment"
        let parameters = [
            "fname": fName,
            "lname": lName,
            "dob":   dob
        ]
        
        Alamofire.request( .GET, url, parameters: parameters, encoding: .URL ).responseJSON
        {
            request, response, json, error in
            
            if let jsonResult = json as? NSDictionary
            {
                if jsonResult.count == 0
                {
                    completionHandler( responseObject: nil )
                }
                else
                {
                    var information = NSMutableDictionary()
                    let email = jsonResult.objectForKey("email") as String
                    let apptID = jsonResult.objectForKey("_id") as String
                    let fName = jsonResult.objectForKey("fname") as String
                    let lName = jsonResult.objectForKey("lname") as String
                    let dob = jsonResult.objectForKey("dob") as String
                    information.setValue(fName, forKey: "fname")
                    information.setValue(lName, forKey: "lname")
                    information.setValue(dob, forKey: "dob")
                    information.setValue(email, forKey: "email")
                    information.setValue(apptID, forKey: "appointmentID")
                    
                    let dateString = jsonResult.objectForKey("date") as String
                    let removedT = dateString.stringByReplacingOccurrencesOfString("T", withString: " ", options: nil, range: nil)
                    let removedTrailing = removedT.stringByReplacingOccurrencesOfString(":00.000Z", withString: "", options: nil, range: nil)
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let date = dateFormatter.dateFromString(removedTrailing)
                    information.setValue(date, forKey: "date")
                    
                    completionHandler( responseObject: information )
                }
            }
            else
            {
                completionHandler( responseObject: nil )
            }
        }
    }
    
    func sendSignature( signature: String, forAppointmentID appointmentID: String, completion: ( success: Bool ) -> () )
    {
        var dispatchTime: dispatch_time_t = dispatch_time( DISPATCH_TIME_NOW, Int64( 3 * Double( NSEC_PER_SEC ) ) )
        dispatch_after( dispatchTime, dispatch_get_main_queue(),
        {
            completion( success: true )
        })
    }
    
    func getCustomForms(completionHandler: (responseObject: NSDictionary? ) -> () )
    {
        let url = baseURL + "form"
        
        Alamofire.request(.GET, url).responseJSON
        {
            request, response, json, error in
            
            if let jsonResult = json as? NSArray
            {
                if let obj = jsonResult.objectAtIndex( 0 ) as? NSDictionary
                {
                    //var fields = obj.objectForKey("fields") as? NSArray
                    completionHandler(responseObject: obj)
                }
            }
        }
    }
    
    
    /*func setState(state:String){
        
        let url = baseURL + state
        
        Alamofire.request(.PUT, url).responseJSON{
             request, response, json, error in
             println(response)
            
        }
        
        
    }*/
    
}