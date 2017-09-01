//
//  WTErrors.swift
//  NameGame
//
//  Created by steig hallquist on 9/1/17.
//  Copyright © 2017 steig hallquist. All rights reserved.
//

import Foundation

let WTErrorMessages:[WTError:String] = [
    .noProfiles : "No profiles were returned.\nIf a filter is set, please adjust filter."
]

enum WTError : Error {
    case noProfiles
    
    var localizedDescription: String {
        return WTErrorMessages[self] ?? "Unknown error"
    }
}
