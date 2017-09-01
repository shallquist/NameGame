//
//  ViewController.swift
//  NameGame
//
//  Created by steig hallquist on 8/31/17.
//  Copyright © 2017 steig hallquist. All rights reserved.


//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var faceButtons: [FaceButton]!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView! {
        didSet {
            activityView.isHidden = true
            activityView.layer.cornerRadius = 7.0
            activityView.layer.borderWidth = 3.0
            activityView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    var wtTeam = WTProfiles()
    var nameFilter:String?

    var maxProfiles:Int!
    var profileToLoad = 0
    
    var currentIndex:Int = 0
    var currentProfile:WTProfile?
    
    
    var profilesLoaded:Int = -1 {
        didSet {
            activityView.isHidden = profilesLoaded == profileToLoad
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //ensures that the activity view is the top view
        self.view.bringSubview(toFront: activityView)
        //limit number of profiles to number of buttons available
        self.maxProfiles = faceButtons.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    func loadData() {
        activityView.isHidden = false
        
        wtTeam.loadData(handler: { error in
            self.activityView.isHidden = true
            
            if error == nil {
                self.newGame()
            } else {
                self.errorMessage(error: error)
            }
        })
    }
    
    func newGame(_ filter:String? = nil) {
        
        /*
        let filteredList = wtTeam.profiles.filter({ (wtProfile) -> Bool in
            return filter == nil || wtProfile.firstName.hasPrefix(filter!)
        })
        
        guard let list = filteredList.randomItems(maxItems: maxProfiles), list.count > 0 else {
            errorMessage(error: WTError.noProfiles)
            return
        }
        */
        
        do {
            let list = try wtTeam.getFiltredList(count: maxProfiles, filter: filter)
            
            clearButtons()
            self.profilesLoaded = 0

            
            profileToLoad = list.count
            currentIndex = Int(arc4random_uniform(UInt32(list.count)))
            currentProfile = list[currentIndex]
            
            self.title = "Who is \(list[currentIndex].fullName)?"
            
            for (index, value) in list.enumerated() {
                let cButton = faceButtons[index]
                
                cButton.setup(title: value.fullName, id: index)
                
                DispatchQueue.global().async {
                    let photo = value.getImage()
                    
                    DispatchQueue.main.async {
                        cButton.setBackgroundImage(photo, for: .normal)
                        self.profilesLoaded += 1
                    }
                }
            }
        } catch  {
            self.errorMessage(error: error)
        }
    }
    
    func clearButtons() {
        for button in faceButtons {
            button.setup()
        }
    }
    
    
    func errorMessage(error:Error?) {
        var message:String
        
        if let myError = error as? WTError {
            message = myError.localizedDescription
        } else {
            message = error?.localizedDescription ?? "Unknown Error"
        }
        
        let alertVC = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alertVC, animated: true, completion: nil)
    }

    @IBAction func faceButtonAction(_ sender: UIButton) {
        guard let cButton = sender as? FaceButton else { return }
        
        if cButton.checkGuess(guess: currentIndex) {
            //when correctly guessed remove the profile from the list
            wtTeam.removeProfile(profile: currentProfile)
        }
    }
    
    @IBAction func filterAction(_ sender: UIBarButtonItem) {
        let message = "Enter one or more letters of a persons first name to filter the list of profiles.\nNo wild cards are necessary."
        
        let alertVC = UIAlertController(title: "Filter", message: message, preferredStyle: .alert)
        var inputText:UITextField?
        
        alertVC.addTextField(configurationHandler: {textField in
            textField.placeholder = "Filter"
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .no
            textField.text = self.nameFilter
            inputText = textField
        })
        
        let setAction = UIAlertAction(title: "Set", style: .default) { (alertAction) in
            self.nameFilter = inputText?.text
            self.newGame(self.nameFilter)
        }

        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (_) in
            self.nameFilter = nil
            self.newGame(self.nameFilter)
        }
        
        alertVC.addAction(setAction)
        alertVC.addAction(removeAction)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func playGame(_ sender: UIBarButtonItem) {
        newGame(self.nameFilter)
    }
}

