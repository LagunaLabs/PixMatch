//
//  MainViewController.swift
//  PixMatch
//
//  Created by Justin Honda on 9/19/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import LBTAComponents
import Firebase
import FirebaseFunctions
import SQLite3
import UIKit

class MainViewController: UIViewController {
    
    // Mark: - Database
    var db: OpaquePointer?
    var winners = [WinInfo]()
    
    // Mark: - Properties
    var pickedBoxes: [UIImageView] = []
    
    var numberOfBoxesTouched = 0 // used to run matching logic
    
    var shuffledColorsArray: [UIColor] = []
    
    var winningTimeString = ""
    
    var hasStartedGame = false
    
    var timeInSeconds: Int = 0
    
    var matchesIncrementer: Int = 0 {
 
        didSet {
            // run didUserWinYet logic (pause timer if won and provide user way to enter their name if score reaches top 5)
            print("There are " + String(matchesIncrementer) + " matches.")
            if matchesIncrementer == 4 {
                print("you won the game!")
                timer.invalidate()
                winningTimeString = timerLabel.text!
                print("Your winning time is: ", winningTimeString)
                displayWinAlert(withWinningTime: winningTimeString)
            }
        }
    }
    
    var timer = Timer()
    
    var viewWidth: CGFloat {
        return view.frame.width
    }
    
    var viewHeight: CGFloat {
        return view.frame.height
    }
    
    // Mark: - UI Elements
    
    lazy var functions = Functions.functions()
    
    lazy var timerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0:00:00"
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        // TODO: - Dynamically size
        lbl.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        lbl.font = UIFont(name: "Arial", size: 32)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var vertStackViewOne: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.alignment = .fill
        vStack.spacing = 5
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    lazy var vertStackViewTwo: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.alignment = .fill
        vStack.spacing = 5
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    lazy var vertStackViewThree: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.alignment = .fill
        vStack.spacing = 5
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    lazy var horizStackViewMain: UIStackView = {
        let stkView = UIStackView()
        stkView.frame = CGRect(x: 0, y: 0, width: 0.75 * viewWidth, height: 0.75 * viewWidth)
        stkView.spacing = 5
        stkView.distribution = UIStackView.Distribution.fillEqually
        stkView.backgroundColor = .green
        stkView.axis = NSLayoutConstraint.Axis.horizontal
        return stkView
    }()
    
    lazy var boxOne: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.darkGray
        imgView.layer.cornerRadius = 8
        imgView.tag = 1
        imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgView.frame.size = CGSize.init(width: 50, height: 50)
        imgView.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(flipOverCard))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        tapGR.name = "boxOne"
        imgView.addGestureRecognizer(tapGR)
        return imgView
    }()
    
    lazy var boxTwo: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.darkGray
        imgView.layer.cornerRadius = 8
        imgView.tag = 2
        imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgView.frame.size = CGSize.init(width: 50, height: 50)
        imgView.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(flipOverCard))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        tapGR.name = "boxTwo"
        imgView.addGestureRecognizer(tapGR)
        return imgView
    }()
    
    lazy var boxThree: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.darkGray
        imgView.layer.cornerRadius = 8
        imgView.tag = 3
        imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgView.frame.size = CGSize.init(width: 50, height: 50)
        imgView.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(flipOverCard))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        tapGR.name = "boxThree"
        imgView.addGestureRecognizer(tapGR)
        return imgView
    }()
    
    lazy var boxFour: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.darkGray
        imgView.layer.cornerRadius = 8
        imgView.tag = 4
        imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgView.frame.size = CGSize.init(width: 50, height: 50)
        imgView.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(flipOverCard))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        tapGR.name = "boxFour"
        imgView.addGestureRecognizer(tapGR)
        return imgView
    }()
    
    lazy var middleBox: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.black
        imgView.layer.cornerRadius = 8
        imgView.tag = 0
        imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgView.frame.size = CGSize.init(width: 50, height: 50)
        return imgView
    }()
    
    lazy var boxFive: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.darkGray
        imgView.layer.cornerRadius = 8
        imgView.tag = 5
        imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgView.frame.size = CGSize.init(width: 50, height: 50)
        imgView.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(flipOverCard))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        tapGR.name = "boxFive"
        imgView.addGestureRecognizer(tapGR)
        return imgView
    }()
    
    lazy var boxSix: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.darkGray
        imgView.layer.cornerRadius = 8
        imgView.tag = 6
        imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgView.frame.size = CGSize.init(width: 50, height: 50)
        imgView.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(flipOverCard))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        tapGR.name = "boxSix"
        imgView.addGestureRecognizer(tapGR)
        return imgView
    }()
    
    lazy var boxSeven: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.darkGray
        imgView.layer.cornerRadius = 8
        imgView.tag = 7
        imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgView.frame.size = CGSize.init(width: 50, height: 50)
        imgView.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(flipOverCard))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        tapGR.name = "boxSeven"
        imgView.addGestureRecognizer(tapGR)
        return imgView
    }()
    
    lazy var boxEight: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.darkGray
        imgView.layer.cornerRadius = 8
        imgView.tag = 8
        imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgView.frame.size = CGSize.init(width: 50, height: 50)
        imgView.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(flipOverCard))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        tapGR.name = "boxEight"
        imgView.addGestureRecognizer(tapGR)
        return imgView
    }()
    
    lazy var horizStackViewBottom: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .equalCentering
        return hStack
    }()
    
    lazy var newGameButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("New Game", for: .normal)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .blue
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        // Shadow
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowRadius = 8
        btn.layer.shadowOffset = .zero
        btn.layer.shadowOpacity = 0.5
        btn.addTarget(self, action: #selector(resetForNewGame), for: .touchUpInside)
        return btn
    }()
    
    lazy var seeTopScoresButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Best Times", for: .normal)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .blue
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        // Shadow
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowRadius = 8
        btn.layer.shadowOffset = .zero
        btn.layer.shadowOpacity = 0.5
        btn.addTarget(self, action: #selector(testFirebaseFunctions), for: .touchUpInside)
        return btn
    }()
    
    // Mark: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("testTEST.sqlite")
        var d: OpaquePointer?
        
        if sqlite3_open(fileURL.path, &d) != SQLITE_OK {
            print("error opening database")
        } else {
            db = d
            print("Successfully opened connection to database at \(fileURL.path)")
        }
        
        let query = "CREATE TABLE IF NOT EXISTS Winners (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, time TEXT)"
        
        if sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        DispatchQueue.main.async {
            self.loadUIElements { (success) in
                if success {
                    print("Successful loading of UI Elements")
                }
            }
        }
        randomizeColorsAndBoxArrays()
    }

}


