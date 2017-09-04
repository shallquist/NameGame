//
//  Extensions.swift
//  NameGame
//
//  Created by steig hallquist on 8/31/17.
//  Copyright © 2017 steig hallquist. All rights reserved.
//

import Foundation

extension Array {
    // given a number of elements requested returns a list of random elements of that size
    func randomItems(maxItems:Int) -> [Element]? {
        if isEmpty { return nil }
        
        var indexSet = IndexSet()
        var randoms = [Element]()
        
        while randoms.count < Swift.min(self.count, maxItems) {
            let index = Int(arc4random_uniform(UInt32(self.count)))
            
            if !indexSet.contains(index) {
                indexSet.insert(index)
                randoms.append(self[index])
            }
        }
        
        return randoms
    }
}
