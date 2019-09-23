//
//  WelcomeViewController.swift
//  PixMatch
//
//  Created by Justin Honda on 9/22/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import FirebaseFirestore
import LBTAComponents
import UIKit

class WelcomeViewController: UIViewController {
    
    var dbF = Firestore.firestore()
    
    lazy var welcomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Service.boldFontWithSize24
        lbl.textColor = .white
        lbl.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        lbl.textAlignment = .center
        lbl.text = "Welcome to PixMatch!"
        return lbl
    }()
    
    /// Text field for user to input email address
    /// * Example: `email@email.com`
    lazy var emailTextField: UITextField = {
        let txtField = UITextField()
        txtField.borderStyle = .roundedRect
        txtField.borderRect(forBounds: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        txtField.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        txtField.layer.cornerRadius = 8
        txtField.frame.size.height = 50
        txtField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                            attributes: [NSAttributedString.Key.foregroundColor: Service.firebaseOrange, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 20.0)!])
        txtField.textColor = Service.firebaseBlue
        txtField.clearButtonMode = .whileEditing
        txtField.addTarget(self, action: #selector(textFieldEditingDidChange), for: .allEditingEvents)
        txtField.autocapitalizationType = .none
        txtField.keyboardAppearance = .dark
        txtField.delegate = self
        return txtField
    }()
    
    /// Separator to separate email text field from password text field
    lazy var mediumSeperator: UIButton = {
        let btn = UIButton()
        btn.layer.backgroundColor = UIColor.gray.cgColor
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    /// Text field for user to input password
    /// - Note: Secure-entry is provided as default
    lazy var passwordtextField: UITextField = {
        let txtField = UITextField()
        txtField.borderStyle = .roundedRect
        txtField.borderRect(forBounds: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        txtField.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        txtField.layer.cornerRadius = 8
        txtField.frame.size.height = 50
        txtField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                            attributes: [NSAttributedString.Key.foregroundColor: Service.firebaseOrange, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 20.0)!])
        txtField.textColor = Service.firebaseBlue
        txtField.clearButtonMode = .whileEditing
        txtField.autocapitalizationType = .none
        txtField.isSecureTextEntry = true
        txtField.keyboardAppearance = .dark
        txtField.delegate = self
        return txtField
    }()
    
    /// Separator to creat visual border underneath the password text field
    lazy var longSeperatorTwo: UIButton = {
        let btn = UIButton()
        btn.layer.backgroundColor = UIColor.gray.cgColor
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    /// Custom sign in button for Firebase users
    lazy var firebaseLoginButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.backgroundColor = Service.firebaseBlue
        btn.tintColor = .white
        btn.setTitle("Login with Email", for: .normal)
        let font = Service.fontWithSize16
        btn.titleLabel?.font = font
        btn.isUserInteractionEnabled = true
        btn.tag = 2
        btn.addTarget(self, action: #selector(handleEmailSignIn), for: .touchUpInside)
        return btn
    }()
    
    /// Firebase icon image view
    lazy var firebaseLoginIconView: UIImageView = {
        let imgView = UIImageView()
        imgView.frame.size = CGSize(width: 40, height: 40)
        imgView.image = #imageLiteral(resourceName: "ic_firebase").withRenderingMode(.alwaysOriginal)
        return imgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        loadUIElements()
    }
    
    
    private func loadUIElements() {

        view.addSubview(welcomeLabel)
        view.addSubview(emailTextField)
        view.addSubview(mediumSeperator)
        view.addSubview(passwordtextField)
        view.addSubview(firebaseLoginButton)
        view.addSubview(firebaseLoginIconView)

        welcomeLabel.center.x = view.center.x
        welcomeLabel.center.y = view.frame.height * 0.2
        
        emailTextField.anchor(welcomeLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 50)
        mediumSeperator.anchor(emailTextField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 1)
        passwordtextField.anchor(emailTextField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 1, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 50)
        firebaseLoginButton.anchor(passwordtextField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 50)
        firebaseLoginIconView.anchor(firebaseLoginButton.topAnchor, left: firebaseLoginButton.leftAnchor, bottom: firebaseLoginButton.bottomAnchor, right: nil, topConstant: 5, leftConstant: 8, bottomConstant: 5, rightConstant: 0, widthConstant: 40, heightConstant: 40)
    
    }
}

extension WelcomeViewController {
    @objc func handleEmailSignIn() {
        // Get email and password
        
        // Create a reference to the cities collection
        let citiesRef = dbF.collection("users")

        // Create a query against the collection.
        let query = citiesRef.whereField("password", isEqualTo: passwordtextField.text)
        print(query.whereField("password", isEqualTo: passwordtextField.text!))
        query.getDocuments { (snap, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snap!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
                
            }
        }
//        let query = usersRef.whereField("password", isEqualTo: passwordtextField.text!)
//        print(query)
        
        
        
        
//        dbF.collection("users").getDocuments { (snap, error) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                let alertController = UIAlertController(title: "PixMatch", message: error?.localizedDescription, preferredStyle: .alert)
//                let acknowledgeAction = UIAlertAction(title: "Ok!", style: .default) { (action) in
//                    alertController.dismiss(animated: true, completion: nil)
//                }
//                alertController.addAction(acknowledgeAction)
//                self.show(alertController, sender: nil)
//            } else {
//                for doc in snap!.documents {
//                    print(doc.data() as Any)
//                }
//            }
//        }
        
        
        
        // Check of equal
        // Show game view controller if match
    }
}

extension WelcomeViewController: UITextFieldDelegate {
    
    //MARK: - UITextField Helpers
    
    /**
     Monitors each edit made in a text field
     - Parameter textField: The text field whose text did change.
     */
    @objc func textFieldEditingDidChange(forTextField textField: UITextField) {
        print(textField.text as Any)
    }
    
    /**
     If user taps "return" button on keyboard, then the keyboard will dismiss.
     - Returns: True
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /// Option-click for info
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        /// Option-click for info
        textField.resignFirstResponder()
    }
    
    /**
     Adds a gesture recognizer to allow the user to tap anywhere
     to dismiss the keyboard.
     */
    fileprivate func addDismissKeyboardGestureRecognizer() {
        /// Instance of a tap gesture recognizer
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        /// Option-click for info
        tap.cancelsTouchesInView = false
        /// Adds tap gesture recognizer to entire view
        self.view.addGestureRecognizer(tap)
    }
    
}
