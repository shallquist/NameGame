//
//  WTProfiles.swift
//  NameGame
//
//  Created by steig hallquist on 8/31/17.
//  Copyright © 2017 steig hallquist. All rights reserved.
//

import UIKit
import Alamofire

class WTProfiles: NSObject {
    let wtURL = URL(string: "https://willowtreeapps.com/api/v1.0/profiles")
    
    var profiles = [WTProfile]()
    
    func loadData(handler: @escaping (_ error:Error?)->Void) {
        guard wtURL != nil else {
            return
        }
        
        //need to remove any previously loaded profiles when user resets game
        profiles.removeAll()
        
        Alamofire.request(wtURL!)
            .validate()
            .responseJSON { (response) in
                if let profiles = response.result.value as? [[String : Any?]] {
                    self.setProfiles(profiles: profiles)
                }
                
                //return any errors to the calling routine
                handler(response.error)
        }
    }
    
    func setProfiles(profiles:[[String:Any?]]) {
        for elem in profiles {
            if let newProfile = WTProfile(dict: elem) {
                self.profiles.append(newProfile)
            }
        }
    }
    
}
