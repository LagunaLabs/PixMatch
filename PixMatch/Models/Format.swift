//
//  Format.swift
//  PixMatch
//
//  Created by Justin Honda on 9/20/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import Foundation

public struct Format {
    
    
    static func time(_ seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds))!
    }
}
