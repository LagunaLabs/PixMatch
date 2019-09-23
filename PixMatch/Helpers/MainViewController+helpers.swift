//
//  MainViewController+helpers.swift
//  PixMatch
//
//  Created by Justin Honda on 9/20/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import Firebase
import FirebaseFunctions
import FirebaseDatabase
import LBTAComponents
import SQLite3
import UIKit

// Helper methods
extension MainViewController {
    
    @objc func testFirebaseFunctions() {}
    
    /**
     * When the player wins the game, they have the option to add their score to the database.
     */
    func addWinningTimeToDatabase(forUser user: String, withTime time: String) {
        /// Creates instance of the Firestore database
        let db = Firestore.firestore()
        /// Sends the winning score to the the collection
        db.collection("publicScores").document(user).setData(["time": time]) { (error) in /// "/../" gets sensitive data
            if error != nil {
                print(error?.localizedDescription as Any)
                let alertController = UIAlertController(title: "PixMatch", message: error?.localizedDescription, preferredStyle: .alert)
                let acknowledgeAction = UIAlertAction(title: "Ok!", style: .default) { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(acknowledgeAction)
                self.show(alertController, sender: nil)
            }
        }
    }
    
    //
    //    db.collection("publicScores").getDocuments { (snap, error) in
    //    if error != nil {
    //    print(error?.localizedDescription)
    //    }
    //
    //    for data in snap!.documents {
    //    print(data.data() as Any)
    //    }
    //    }
    //    db.collection("publicScores").document("Justin").getDocument(source: .server) { (snap, error) in
    //    if error != nil {
    //    print(error?.localizedDescription)
    //    }
    //    print(snap?.data() as Any)
    //    }
    
    
    
    //        Functions.functions().httpsCallable("https://us-central1-pixmatch-19de5.cloudfunctions.net/helloWorld").call { (result, error) in
    //            print(result?.data as Any)
    //        }
    //        functions.httpsCallable("https://us-central1-pixmatch-19de5.cloudfunctions.net/helloWorld").call { (result, error) in
    //            print(result?.data as Any)
    //        }
    //
    //        functions.httpsCallable("helloWorld").call { (result, error) in
    //            if error != nil {
    //                print("Error Firebase function: ", error?.localizedDescription)
    //            }
    //            print(result?.data as Any)
    //        }
    
    //        functions.httpsCallable("helloWorld").call(["text": "Hello Firebase!"]) { (result, error) in
    //            if let error = error as NSError? {
    //                if error.domain == FunctionsErrorDomain {
    //                    let code = FunctionsErrorCode(rawValue: error.code)
    //                    let message = error.localizedDescription
    //                    let details = error.userInfo[FunctionsErrorDetailsKey]
    //                     print("Error calling Hello World in Firebase functions")
    //                }
    //                // ...
    //                print("Error calling Hello World in Firebase functions")
    //                print(error.localizedDescription)
    //            }
    //            if let text = (result?.data as? [String: Any])?["text"] as? String {
    //                //self.resultField.text = text
    //                print("From Firebase function: ", text)
    //            }
    //        }
    
    
    func displayWinAlert(withWinningTime time: String) {
        
        /// Instance of winning information class
        var winInformation: WinInfo?
        /// Instance of alert controller
        let alertController = UIAlertController(title: "PixMatch", message: "You won with a time of " + time, preferredStyle: .alert)
        
        /// Adds text field to alert controller
        alertController.addTextField { (textField) in }
        
        /// Action to send time to database for the player
        let submitNameAlertAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            
            // TODO: - This is where we will create the injection attack
            
            /// Extracted text input
            let txtField: UITextField = alertController.textFields!.first!
            /// Initialize WinInfo variable
            winInformation = WinInfo(name: txtField.text ?? "", time: time)
            /// print inputted text
            print(txtField.text!)
            /// Set up call to database
            self.addWinningTimeToDatabase(forUser: winInformation!.name, withTime: time)
        }
        
        /// Simple acknowledge button that dismissies alert controller
        let acknowledgeAlertAction = UIAlertAction(title: "Ok!", style: .cancel) { (action) in
            print("User acknowledged and is ready to play again!")
        }
        
        /// Add each alert action to the alert controller
        alertController.addAction(submitNameAlertAction)
        alertController.addAction(acknowledgeAlertAction)
        
        /// Display the alert controller
        self.show(alertController, sender: nil)
    }
    
    /**
     * Called in timer to increment the timer variable
     */
    func eachSecond() -> Int {
        return 1
    }
    
    /**
     * Prepares new game for player setting all variables and UI elements to default
     */
    @objc func resetForNewGame() {
        shuffledColorsArray = []
        matchesIncrementer = 0
        hasStartedGame = false
        winningTimeString = ""
        numberOfBoxesTouched = 0
        timerLabel.text = "0:00:00"
        timeInSeconds = 0
        pickedBoxes = []
        if timer.isValid {
            timer.invalidate()
        }
        randomizeColorsAndBoxArrays()
        
        let boxArray: [UIImageView] = [boxOne, boxTwo, boxThree, boxFour, boxFive, boxSix, boxSeven, boxEight]
        boxArray.forEach { (imgView) in
            imgView.backgroundColor = .darkGray
        }
    }
    
    func randomizeColorsAndBoxArrays() {
        /// Assign random pairs of colors to each box
        /// Colors used for 8 boxes will be 4 pairs. (Gold - #D8AB4C; Red - #F71735; Aqua - #41EAD4; White - #FDFFFC)
        var boxColorArray = [BoxColors.gold, BoxColors.aqua, BoxColors.red, BoxColors.white]
        
        /// adds each color one more time to array for a total of 8 colors for 8 boxes. Only two of each color is present.
        boxColorArray.append(contentsOf: boxColorArray)
        
        /// Shuffled array of box colors
        let shuffledBoxColorArray = boxColorArray.shuffled()
        
        /// Randomly assigns each color in the color array to class array variable
        shuffledBoxColorArray.forEach { (color) in
            self.shuffledColorsArray.append(color)
        }
    }
    
    /**
     * Loads all UI elements for default state of MainViewController view
     */
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
        
        view.addSubview(timerLabel)
        view.bringSubviewToFront(timerLabel)
        timerLabel.center = view.center
        
        
        var widthAndHeightOfButtons: Float = 0
        if (horizStackViewMain.frame.width / 3) > 120 {
            widthAndHeightOfButtons = 120
        } else if (horizStackViewMain.frame.width / 3) < 103.5 {
            widthAndHeightOfButtons = Float((horizStackViewMain.frame.width / 3) - horizStackViewMain.spacing)
        } else {
            widthAndHeightOfButtons = Float((horizStackViewMain.frame.width / 3) - horizStackViewMain.spacing)
        }
        
        
        timerLabel.frame = CGRect(x: 0, y: 0, width: CGFloat(widthAndHeightOfButtons), height: CGFloat(widthAndHeightOfButtons))
        timerLabel.center = view.center // must readjust position when changing frame without doing math for resetting x: and y:
        
        view.addSubview(seeTopScoresButton)
        seeTopScoresButton.anchor(boxThree.bottomAnchor, left: boxThree.leftAnchor, bottom: nil, right: nil, topConstant: 64, leftConstant: ((horizStackViewMain.frame.width / 3) - horizStackViewMain.spacing - CGFloat(widthAndHeightOfButtons)) / 2, bottomConstant: 0, rightConstant: 0, widthConstant: CGFloat(widthAndHeightOfButtons), heightConstant: CGFloat(widthAndHeightOfButtons))
        seeTopScoresButton.layer.cornerRadius = CGFloat(widthAndHeightOfButtons / 2)
        
        view.addSubview(newGameButton)
        newGameButton.anchor(boxEight.bottomAnchor, left: boxEight.leftAnchor, bottom: nil, right: nil, topConstant: 64, leftConstant: ((horizStackViewMain.frame.width / 3) - horizStackViewMain.spacing - CGFloat(widthAndHeightOfButtons)) / 2, bottomConstant: 0, rightConstant: 0, widthConstant: CGFloat(widthAndHeightOfButtons), heightConstant: CGFloat(widthAndHeightOfButtons))
        newGameButton.layer.cornerRadius = CGFloat(widthAndHeightOfButtons / 2)
        completion(true)
    }
    
    /**
     * Performed every time two boxes are selected to check if they have the same background color.
     */
    func matchingLogic() {
        /// Check if colors match
        if (pickedBoxes[0].backgroundColor?.isEqual(pickedBoxes[1].backgroundColor))! { /// Colors match
            /// Increment matches counter. When there are <em>n</em> boxes, and the incrementer satisfies <em>n / 2</em>, the player has won the game.
            matchesIncrementer += 1
        } else { /// Colors do not match
            /// Animate boxes background colors back to the default color
            UIView.animate(withDuration: 1.25) {
                self.pickedBoxes[0].backgroundColor = Common.boxDefaultColor
                self.pickedBoxes[1].backgroundColor = Common.boxDefaultColor
            }
        }
        /// reset array
        pickedBoxes = []
    }
    
    /**
     * Called when timer fires every 1 second updating the timer label to indicate to the user how much time has passed since they began their current game.
     */
    func updateTimerLabel() {
        timerLabel.text = Format.time(timeInSeconds)
    }
    
    /**
     * A timer is fired at the beginning of every game then fires at 1 second intervals.
     */
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timr) in
            self.timeInSeconds += self.eachSecond()
            self.updateTimerLabel()
        })
        timer.fire()
    }
    
    /**
     * When the player touches a box, it reveals its hidden color.
     */
    @objc func flipOverCard(_ sender: UITapGestureRecognizer) {
        /// Check if a game has began
        if hasStartedGame == false {
            startTimer()
        }
        /// Boolean for state of game play
        hasStartedGame = true
        
        /// Ensure box has a tag before switching on it
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
        /// Maximum number reaches 2, then resets back to zero.
        numberOfBoxesTouched += 1
        if numberOfBoxesTouched == 2 {numberOfBoxesTouched = 0; matchingLogic()}
    }
    
}
