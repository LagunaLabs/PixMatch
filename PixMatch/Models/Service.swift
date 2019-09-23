//
//  Service.swift
//  MapMySigns
//
//  Created by Justin Honda on 6/26/18.
//  Copyright © 2018 Justin Honda. All rights reserved.
//

import UIKit
import LBTAComponents
import CoreLocation
import MapKit
import Firebase


/// Class to provide universal services for all view controllers
/// when needed. Helpful when certain properties are identical across several
/// view controllers.
class Service: NSCoder, CLLocationManagerDelegate {
    
    static let baseColor = UIColor(r: 254, g: 202, b: 64)
    static let darkBaseColor = UIColor(r: 253, g: 166, b: 47)
    static let unselectedItemColor = UIColor(r: 173, g: 173, b: 173)
    static let facebookBlue = UIColor.init(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
    static let googleRed = UIColor.init(red: 219/255, green: 68/255, blue: 55/255, alpha: 1)
    static let firebaseBlue = UIColor.init(red: 5/255, green: 155/255, blue: 229/255, alpha: 1)
    static let firebaseOrange = UIColor.init(red: 255/255, green: 166/255, blue: 17/255, alpha: 1)
    /**System font: Size `CGFloat` = 16*/
    static let fontWithSize16 = UIFont.systemFont(ofSize: 16)
    /**Bold system font: Size `CGFloat` = 24*/
    static let boldFontWithSize24 = UIFont.boldSystemFont(ofSize: 24)
    static let letterPressStyleTextEffect = NSAttributedString.TextEffectStyle.letterpressStyle
    static let displayNameAttributeOne = [NSAttributedString.Key.font: Service.boldFontWithSize24, NSAttributedString.Key.textEffect: Service.letterPressStyleTextEffect, NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key : Any]
    
    static let appleBlue = UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1)
    static let appleGreen = UIColor.init(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    static let appleRed = UIColor.init(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
    static let termsOfServiceLink = "https://www.helpyoself.com"
    static let privacyPolicy = "https://www.google.com"
    
    static let connectedRef = Database.database().reference(withPath: ".info/connected")
    static let usersRootDatabaseReference = Database.database().reference(withPath: "Users") // Root for Users in database
    static let publicSignsRootDatabaseReference = DatabaseReference().child("PublicSigns") // For public signs
    
    /// Process the current Date by formatting it to specification
    ///
    /// Calling this method returns the date in raw format of type Date
    /// as well as the prescribed date format of type String.
    ///
    /// - Parameter date: The date at the time of calling this method
    ///
    /// - Returns: Date instance used and the date string created from it. (Date, String)
    static func date(fromDate date: Date) -> (Date, String)  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long //e.g. -> Saturday, July 7, 2018
        dateFormatter.locale = Calendar.current.locale
        
        let formattedDateString = dateFormatter.string(from: date)
        let formattedDate = dateFormatter.date(from: formattedDateString)
        return (formattedDate!, formattedDateString)
    }
    
    /// Process the current Date by formatting it to specification
    ///
    /// Calling this method returns the date in raw format of type Date
    /// as well as the prescribed date format of type String.
    ///
    /// - Parameter date: The date at the time of calling this method
    ///
    /// - Returns: Date instance used and the date string created from it. (Date, String)
    static func date(fromDate dateString: String) -> (Date?, String)  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long //e.g. -> Saturday, July 7, 2018
        dateFormatter.locale = Calendar.current.locale
        return (dateFormatter.date(from: dateString), dateString)
    }
    
    // Returns the date instance used and the string created from this data as time.
    
    /// Process the current Date by formatting it to specification and
    /// converting it to time.
    ///
    /// Calling this method returns the date in raw format of type Date
    /// as well as the prescribed time format of type String.
    ///
    /// - Parameter date: The date at the time of calling this method
    ///
    /// - Returns: Date instance used and the time string created from it.
    static func time(fromDate date: Date) -> (Date, String) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = Calendar.current.timeZone
        timeFormatter.timeStyle = .full //e.g. -> 12:40:46 AM Eastern Daylight Time
        return (date, timeFormatter.string(from: date))
    }

    /// Used when receiving the latitude and longitude from the users
    /// sign property located in the Firebase Realtime Database.
    ///
    /// Calling this method splits the string to return a latitude
    /// and longitude separately. The latitude and longitude are required
    /// to be separated and then converted to type Double to use in the
    /// MKPointAnnotation class.
    ///
    /// - Parameter string: The combined lat-long string
    ///
    /// - Returns: Latitude and Longitude in String form
    func splitLatLong(string: String) -> (String, String) {
        let array = string.components(separatedBy: "|")
        return (array[0], array[1])
    }
    
    
    /// Used to split a string by passing a character with which to
    /// separate it.
    ///
    /// Calling this method splits the string and returns (n + 1)
    /// separate strings where `n` is the number of given characters
    /// existing in the string to be split
    ///
    /// - Parameters:
    ///     - char: The character used to split a string
    ///     - string: The passed string to be split
    /// - Returns: Array of separated strings in order from left-to-right
    func splitString(withChar char: String, onString string: String) -> [String] {
        return string.components(separatedBy: char)
    }
    
    /// Creates an instance of UIAlertController in order to begin configuring
    /// an alert controller or action sheet
    /// - Parameters:
    ///    - title: Title of alert controller or action sheet.
    ///    - message: Main body of alert controller or action sheet.
    ///    - style: Style (.alert or .actionSheet)
    /// - Returns: Configured alert controller or action sheet. Actions still need to be added.
    func configureAlertController(withTitle title: String?, withMessage message: String?, withStyle style: UIAlertController.Style) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: style)
    }
    
    func displayActionSheet(title: String?, message: String?, style: UIAlertController.Style) {
//        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: style)
//        let action = UIAlertAction(title: title, style: ., handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
 
    }
    

    
}


// MARK: - UIButton extension

extension UIButton {
    
    /**
     Adds title and title color simultaneously instead of making separate calls.
     
     - Parameters:
     - title: Tile of button
     - color: Color of title
     */
    func setTitleColor(withTitle title: String, withColor color: UIColor) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
    }
}
