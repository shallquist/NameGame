//
//  FaceButton.swift
//  NameGame
//
//  Created by Intern on 3/11/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

open class FaceButton: UIButton {

    var id: Int = 0
    var tintView: UIView = UIView(frame: CGRect.zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

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

    func checkGuess(guess:Int)->Bool {
        tintView.alpha = 0.25
        titleLabel?.alpha = 1.0

        if id == guess {
            tintView.backgroundColor = UIColor.green
        } else {
            tintView.backgroundColor = UIColor.red
        }
        
        return id == guess
    }
}
