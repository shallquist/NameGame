//
//  ViewController.swift
//  NameGame
//
//  Created by steig hallquist on 8/31/17.
//  Copyright © 2017 steig hallquist. All rights reserved.


//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!

    @IBOutlet var faceButtons: [FaceButton]!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView! {
        didSet {
            activityView.isHidden = true
            activityView.layer.cornerRadius = 7.0
            activityView.layer.borderWidth = 3.0
            activityView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    var profiles = WTProfiles()
    var maxProfiles:Int!
    var currentProfile:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //ensures that the activity view is the top view
        self.view.bringSubview(toFront: activityView)
        //limit number of profiles to number of buttons available
        self.maxProfiles = faceButtons.count
        
        configureOrientation(size: self.view.frame.size)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        configureOrientation(size: size)
    }
    
    //Modify the stack view orientations so that the images utilize screen space
    func configureOrientation(size : CGSize) {
        let orientation: UIDeviceOrientation = size.height < size.width ? .landscapeLeft : .portrait
        
        if orientation.isPortrait {
            outerStackView.axis = .vertical
            innerStackView1.axis = .horizontal
            innerStackView2.axis = .horizontal
        } else {
            outerStackView.axis = .horizontal
            innerStackView1.axis = .vertical
            innerStackView2.axis = .vertical
        }
    }
    
    func loadData() {
        activityView.isHidden = false
        
        profiles.loadData(handler: { error in
            self.activityView.isHidden = true
            self.newGame()
        })
    }
    
    func newGame(filter:String? = nil) {
        let filteredList = profiles.profiles.filter({ (wtProfile) -> Bool in
            return filter == nil || wtProfile.firstName.hasPrefix(filter!)
        })
        
        guard let list = filteredList.randomItems(maxItems: maxProfiles), list.count > 0 else {
            return
        }
        
        currentProfile = Int(arc4random_uniform(UInt32(list.count)))
        self.title = "Who is \(list[currentProfile].fullName)?"
        
        for (index, value) in list.enumerated() {
            let cButton = faceButtons[index]
            
            cButton.setup()
            cButton.id = index
            cButton.setTitle(value.fullName, for: .normal)
            
            let photo = value.getImage()
            cButton.setBackgroundImage(photo, for: .normal)
        }
    }

    @IBAction func faceButtonAction(_ sender: UIButton) {
        guard let cButton = sender as? FaceButton else { return }
        
        cButton.checkGuess(guess: currentProfile)
        
        if cButton.id == currentProfile {
            print("Wow!!")
        }
    }
    
    @IBAction func playGame(_ sender: UIBarButtonItem) {
        self.newGame()
    }
}

