//
//  ViewController.swift
//  NameGame
//
//  Created by steig hallquist on 8/31/17.
//  Copyright © 2017 steig hallquist. All rights reserved.
//
/*
    This view controller displays 5 images with a Title at the Top and toolbar on the bottom.
 
    The title displays the full name of the Willow Tree team to guess
    In the body of the view are 5 buttons with image backgrounds of 5 randomly selected WT team members.  
    One of which is the name listed in the title.
 
    When a user touches any button, that button object checks to see if it's a correct guess and adjusts it's display accordingly.
 
    On the toolbar there are three buttons: Play, Filter and reload.
 
    Play - will generate a new random list of profiles an display them on the buttons. Will use the optional filter provided.
    Filter - will show a pop-up which allows the user to enter or remove a filter, which filters the list of profiles by first name
    Reload - will call data to reload the list of profiles from the web service
 
*/

import UIKit

class ViewController: UIViewController {
    @IBOutlet var faceButtons: [FaceButton]!
    
    //setup activity view background layer - bakcground color set in storyboard
    @IBOutlet weak var activityView: UIActivityIndicatorView! {
        didSet {
            activityView.isHidden = true
            activityView.layer.cornerRadius = 7.0
            activityView.layer.borderWidth = 3.0
            activityView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    var wtTeam = WTProfiles()           //object that loads and manages list of profile data
    var nameFilter:String?              //used to filter list by first name

    var maxProfiles:Int!                //maximum number of profiles to be shown in the view
    var profileToLoad = 0               //number of profiles returned from filter
    
    var currentIndex:Int = 0            //index of the profile to guess in the filtered list
    var currentProfile:WTProfile?       //current profile to guess

    //Keeps tracks of the number of profile pictures load requests.
    // Shows activity view whenever number of profiles requested is less than number of profiles to load.
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

    // When view appears call loadData to load profiles from the web service.
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    //calls WTProfiles class to load profile data.  
    //Shows activity view upon start and hides it after data is laoded or there is an error.
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
        do {
            let list = try wtTeam.getFiltredList(count: maxProfiles, filter: filter)
            
            currentIndex = Int(arc4random_uniform(UInt32(list.count)))
            currentProfile = list[currentIndex]
            
            self.title = "Who is \(list[currentIndex].fullName)?"
            
            setupButtons(list: list)
        } catch  {
            self.errorMessage(error: error)
        }
    }
    
    
    //for each profile in the list asynchronously retrieve the image and update the face buttons
    func setupButtons(list:[WTProfile]) {
        //clears all existing data from the buttons - removes images and names
        // this cannot be included in the for loop below, since it can have fewer profiles than buttons
        for button in faceButtons {
            button.setup()
        }

        profilesLoaded = 0
        profileToLoad = list.count

        for (index, value) in list.enumerated() {
            let cButton = faceButtons[index]
            
            cButton.setup(title: value.fullName, id: index)
            
            value.retrieveImage(handler: { (photo, error) in
                self.profilesLoaded += 1
                
                if error == nil {
                    cButton.setBackgroundImage(photo, for: .normal)
                } else {
                    self.errorMessage(error: error)
                }
            })
        }
    }
    
    //displays an alert popup with the message contained in the localized description of the error object
    func errorMessage(error:Error?) {
        // if a UIAlertController is already presented do not present another one
        if self.presentedViewController is UIAlertController {
            return
        }
        
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
    
    // displays a dialogue when user clicks filter button on the toolbar.
    // a user can enter 1 or more characters in the dialogue text field to filter the list by first name or
    // can choose to remove an existing filter
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
        
        let setAction = UIAlertAction(title: "Set Filter", style: .default) { (alertAction) in
            self.nameFilter = inputText?.text
            self.newGame(self.nameFilter)
        }

        let removeAction = UIAlertAction(title: "Remove Filter", style: .default) { (_) in
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
    
    @IBAction func resetGame(_ sender: UIBarButtonItem) {
        self.loadData()
    }
}

