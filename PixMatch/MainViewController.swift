//
//  MainViewController.swift
//  PixMatch
//
//  Created by Justin Honda on 9/19/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import LBTAComponents
import UIKit

class MainViewController: UIViewController {
    
    var numberOfBoxesTouched = 0 // used to run matching logic
    
    var shuffledColorsArray: [UIColor] = []
    
    var matchesIncrementer: Int = 0 {
 
        didSet {
            // run didUserWinYet logic (pause timer if won and provide user way to enter their name if score reaches top 5)
            
        }

    }
    
    var viewWidth: CGFloat {
        return view.frame.width
    }
    
    var viewHeight: CGFloat {
        return view.frame.height
    }
    
    lazy var bottomToolBar: UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.blue
        return vw
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
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .blue
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        // Shadow
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowRadius = 8
        btn.layer.shadowOffset = .zero
        btn.layer.shadowOpacity = 0.5
        return btn
    }()
    
    lazy var seeTopScoresButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Best Times", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .blue
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        // Shadow
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowRadius = 8
        btn.layer.shadowOffset = .zero
        btn.layer.shadowOpacity = 0.5
        return btn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        DispatchQueue.main.async {
            self.loadUIElements { (success) in
                if success {
                    print("Successful loading of UI Elements")
                }
            }
        }
        
        
    }
    
    func loadUIElements(completion: (Bool) -> ()) {
        
        
        view.addSubview(horizStackViewMain)
        horizStackViewMain.center = view.center
        
        vertStackViewOne.insertArrangedSubview(boxOne, at: 0)
        vertStackViewOne.insertArrangedSubview(boxTwo, at: 1)
        vertStackViewOne.insertArrangedSubview(boxThree, at: 2)
        horizStackViewMain.insertArrangedSubview(vertStackViewOne, at: 0)
        
        vertStackViewTwo.insertArrangedSubview(boxFour, at: 0)
        vertStackViewTwo.insertArrangedSubview(middleBox, at: 1)
        vertStackViewTwo.insertArrangedSubview(boxFive, at: 2)
        horizStackViewMain.insertArrangedSubview(vertStackViewTwo, at: 1)
        
        vertStackViewThree.insertArrangedSubview(boxSix, at: 0)
        vertStackViewThree.insertArrangedSubview(boxSeven, at: 1)
        vertStackViewThree.insertArrangedSubview(boxEight, at: 2)
        horizStackViewMain.insertArrangedSubview(vertStackViewThree, at: 2)
        
        view.addSubview(seeTopScoresButton)
        var widthAndHeightOfButtons: Float = 0
        if (horizStackViewMain.frame.width / 3) > 120 {
            widthAndHeightOfButtons = 120
        } else if (horizStackViewMain.frame.width / 3) < 103.5 {
            widthAndHeightOfButtons = Float((horizStackViewMain.frame.width / 3) - horizStackViewMain.spacing)
        } else {
            widthAndHeightOfButtons = Float((horizStackViewMain.frame.width / 3) - horizStackViewMain.spacing)
        }
        
        seeTopScoresButton.anchor(boxThree.bottomAnchor, left: boxThree.leftAnchor, bottom: nil, right: nil, topConstant: 64, leftConstant: ((horizStackViewMain.frame.width / 3) - horizStackViewMain.spacing - CGFloat(widthAndHeightOfButtons)) / 2, bottomConstant: 0, rightConstant: 0, widthConstant: CGFloat(widthAndHeightOfButtons), heightConstant: CGFloat(widthAndHeightOfButtons))
        seeTopScoresButton.layer.cornerRadius = CGFloat(widthAndHeightOfButtons / 2)
        
        view.addSubview(newGameButton)
        newGameButton.anchor(boxEight.bottomAnchor, left: boxEight.leftAnchor, bottom: nil, right: nil, topConstant: 64, leftConstant: ((horizStackViewMain.frame.width / 3) - horizStackViewMain.spacing - CGFloat(widthAndHeightOfButtons)) / 2, bottomConstant: 0, rightConstant: 0, widthConstant: CGFloat(widthAndHeightOfButtons), heightConstant: CGFloat(widthAndHeightOfButtons))
        newGameButton.layer.cornerRadius = CGFloat(widthAndHeightOfButtons / 2)
        
        // Assign random pairs of colors to each box
        // Colors used for 8 boxes will be 4 pairs. (Gold - #D8AB4C; Red - #F71735; Aqua - #41EAD4; White - #FDFFFC)
        
        let boxArray: [UIImageView] = [boxOne, boxTwo, boxThree, boxFour, boxFive, boxSix, boxSeven, boxEight]
        let shuffledBoxArray = boxArray.shuffled()
        let boxColorArray = [BoxColors.gold, BoxColors.aqua, BoxColors.red, BoxColors.white]
        let shuffledBoxColorArray = boxColorArray.shuffled()

        var count = 0
        var assignedColor: UIColor = shuffledBoxColorArray[0]
        
        while count < 8 {
            shuffledColorsArray.append(assignedColor)
            count += 1
            guard count < shuffledBoxArray.count else {continue}
            if count % 2 == 0 { assignedColor = shuffledBoxColorArray[count / 2]}
        }

        print("Shuffled colors:", shuffledColorsArray)
        completion(true)
    }
    
    func matchingLogic() {
        if (pickedBoxes[0].backgroundColor?.isEqual(pickedBoxes[1].backgroundColor))! {
            print("Colors match")
        } else {
            print("Colors do not match")
            UIView.animate(withDuration: 1.5) {
                self.pickedBoxes[0].backgroundColor = .darkGray
                self.pickedBoxes[1].backgroundColor = .darkGray
            }
            
        }
        pickedBoxes = [] // reset array
    }
    
    var pickedBoxes: [UIImageView] = []
    
    @objc func flipOverCard(_ sender: UITapGestureRecognizer) {
        
        
        guard let tag = sender.view?.tag else { return }
        switch tag {
        case boxOne.tag:
            boxOne.backgroundColor = shuffledColorsArray[0]
            pickedBoxes.append(boxOne)
        case boxTwo.tag:
            boxTwo.backgroundColor = shuffledColorsArray[1]
            pickedBoxes.append(boxTwo)
        case boxThree.tag:
            boxThree.backgroundColor = shuffledColorsArray[2]
            pickedBoxes.append(boxThree)
        case boxFour.tag:
            boxFour.backgroundColor = shuffledColorsArray[3]
            pickedBoxes.append(boxFour)
        case boxFive.tag:
            boxFive.backgroundColor = shuffledColorsArray[4]
            pickedBoxes.append(boxFive)
        case boxSix.tag:
            boxSix.backgroundColor = shuffledColorsArray[5]
            pickedBoxes.append(boxSix)
        case boxSeven.tag:
            boxSeven.backgroundColor = shuffledColorsArray[6]
            pickedBoxes.append(boxSeven)
        case boxEight.tag:
            boxEight.backgroundColor = shuffledColorsArray[7]
            pickedBoxes.append(boxEight)
        default:
            break
        }
        numberOfBoxesTouched += 1
        if numberOfBoxesTouched == 2 {numberOfBoxesTouched = 0; print("Run matching logic"); matchingLogic()}
    }
}

// TODO: - Create an initializer extension for UIColor to take a hex string and convert to a color
struct BoxColors {
    static let gold  = UIColor(r: 216, g: 171, b: 76)  // Vanderbilt gold
    static let red   = UIColor(r: 247, g: 23,  b: 53)  // derived with color pallete generator
    static let aqua  = UIColor(r: 65,  g: 234, b: 212) // derived with color pallete generator
    static let white = UIColor(r: 253, g: 255, b: 252) // derived with color pallete generator
}
