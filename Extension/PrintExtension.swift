//
//  PrintExtension.swift
//  GetReady
//
//  Created by leonardo palinkas on 30/10/19.
//  Copyright © 2019 leonardo palinkas. All rights reserved.
//

import Foundation

import UIKit

extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}
