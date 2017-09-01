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
    
    var nameFilter:String?
    
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
            
            if error == nil {
                self.newGame()
            } else {
                self.errorMessage(error: error)
            }
        })
    }
    
    func newGame(_ filter:String? = nil) {
        let filteredList = profiles.profiles.filter({ (wtProfile) -> Bool in
            return filter == nil || wtProfile.firstName.hasPrefix(filter!)
        })
        
        guard let list = filteredList.randomItems(maxItems: maxProfiles), list.count > 0 else {
            errorMessage(error: WTError.noProfiles)
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
        
        if cButton.checkGuess(guess: currentProfile) {
            print("Wow!!")
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

