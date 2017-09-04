//
//  FaceButton.swift
//  NameGame
//
//  Created by Intern on 3/11/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

/*
Class that renders a button in a view with a background image. Provides an image layer that can be tinted to show a correct or
 incorrect guess.
 
*/

import Foundation
import UIKit

open class FaceButton: UIButton {

    var id: Int = 0                                     //used to map the current button to a profile in the filtered list
    var tintView: UIView = UIView(frame: CGRect.zero)   // view that is tinted green or red based on a correct or incorrect guess

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // initialize the button properties
    // ensure the tint layer and button title is not shown by setting alpha to zero (0.0)
    
    func setup(title:String? = nil, id:Int = 0) {
        self.setTitle(title, for: .normal)
        self.id = id
        self.setBackgroundImage(nil, for: .normal)
        
        setTitleColor(.white, for: .normal)
        titleLabel?.alpha = 0.0

        tintView.alpha = 0.0
        tintView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tintView)

        tintView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tintView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tintView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tintView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    // checks to see if the index provided matches the index in the id property
    // if correct tintView and title are tinted green
    // if incorrect tintView and title are tinted red
    func checkGuess(guess:Int)->Bool {
        tintView.alpha = 0.25
        titleLabel?.alpha = 1.0

        if id == guess {
            tintView.backgroundColor = UIColor.green
            setTitleColor(.green, for: .normal)
        } else {
            tintView.backgroundColor = UIColor.red
            setTitleColor(.red, for: .normal)
        }
        
        return id == guess
    }
}
