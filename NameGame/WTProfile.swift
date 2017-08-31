//
//  WTProfile.swift
//  NameGame
//
//  Created by steig hallquist on 8/31/17.
//  Copyright © 2017 steig hallquist. All rights reserved.
//

import UIKit

class WTProfile: NSObject {
    var firstName : String
    var lastName : String
    var imageURL : String
    
    var fullName : String {
        return "\(firstName) \(lastName)"
    }
    
    
    init(firstName:String, lastName:String, imageURL:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.imageURL = imageURL
        
        super.init()
    }
 
    convenience init?(dict:[String : Any?]) {
        guard
            let firstName = dict["firstName"] as? String,
            let lastName = dict["lastName"] as? String,
            let headShot = dict["headshot"] as? [String : Any],
            let imageURL = (headShot["url"] as? String)?.trimmingCharacters(in: CharacterSet.init(charactersIn: "//"))
        else {
            return nil
        }
        
        self.init(firstName: firstName, lastName: lastName, imageURL: imageURL)
    }
    
    
    func getImage()->UIImage? {
        guard
            let url = URL(string:"https://\(imageURL)"),
            let imageData = try? Data(contentsOf: url)
        else {
                return nil
        }
        
        return UIImage(data: imageData)
    }
}