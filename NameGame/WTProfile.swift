//
//  WTProfile.swift
//  NameGame
//
//  Created by steig hallquist on 8/31/17.
//  Copyright © 2017 steig hallquist. All rights reserved.
//

/*
    Class that maintains information for a single profile
    
    Retrieves the profile image from the URL location
 
*/

import UIKit

class WTProfile: NSObject {
    var firstName : String
    var lastName : String
    var imageURL : URL
    
    var fullName : String {
        return "\(firstName) \(lastName)"
    }
    
    
    init(firstName:String, lastName:String, imageURL:URL) {
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
            let urlString = (headShot["url"] as? String)?.trimmingCharacters(in: CharacterSet.init(charactersIn: "//")),
            let imageURL = URL(string:"https://\(urlString)")
        else {
            return nil
        }
        
        //if the image URL contains Test1 then reject it since there appears to be no image associated with that profile
        if urlString.uppercased().contains("TEST1") { return nil }

        self.init(firstName: firstName, lastName: lastName, imageURL: imageURL)
    }
    
    
    // Retrieves the profile image from the URL location using the Data Class contents of initializer
    func getImage()throws->UIImage? {
        do {
            let imageData = try Data(contentsOf: imageURL)
            return UIImage(data: imageData)
        } catch  {
            throw error
        }
    }
    
    // Retrieves the profile image from the URL location using the Data Class contents of initializer
    func retrieveImage(handler:@escaping (_ image:UIImage?,_ error:Error?)->Void) {
        var anImage:UIImage?
        var anError:Error?
        
        DispatchQueue.global().async {
            do {
                let imageData = try Data(contentsOf: self.imageURL)
                anImage = UIImage(data: imageData)
            } catch {
                anError = error
            }

            DispatchQueue.main.async {
                handler(anImage, anError)
            }
        }
    }
}
