//
//  Pose.swift
//  GetReady
//
//  Created by Vinicius Dilay on 07/11/19.
//  Copyright © 2019 leonardo palinkas. All rights reserved.
//

import Foundation
import UIKit
struct Pose {
    let image : UIImage
    let leftArmCase : ShoulderToForearmCase
    let leftHandCase: ForearmToHandSubcase
    
    let rightArmCase : ShoulderToForearmCase
    let rightHandCase: ForearmToHandSubcase
    
    let leftLegCase : LegToKneeCase
    let leftKneeCase: KneeToFootCase
    
    let rightLegCase : LegToKneeCase
    let rightKneeCase: KneeToFootCase
}


class Forms {
    static var shared = Forms()

    let Poses = [
        Pose(image: UIImage(named: "form")!, leftArmCase: .down, leftHandCase: .retoOutstretched, rightArmCase: .up, rightHandCase: .retoOutstretched, leftLegCase: .straight, leftKneeCase: .straight, rightLegCase: .straight, rightKneeCase: .straight),
    ]
}
