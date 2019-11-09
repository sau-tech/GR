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
        Pose(image: UIImage(named: "pose 1")!, leftArmCase: .straight, leftHandCase: .bentUp, rightArmCase: .straight, rightHandCase: .bentDown, leftLegCase: .straight, leftKneeCase: .straight, rightLegCase: .straight, rightKneeCase: .straight),
        Pose(image: UIImage(named: "pose 2")!, leftArmCase: .straight, leftHandCase: .bentUp, rightArmCase: .down, rightHandCase: .retoOutstretched, leftLegCase: .Open, leftKneeCase: .bent, rightLegCase: .straight, rightKneeCase: .straight),
        Pose(image: UIImage(named: "pose 3")!, leftArmCase: .straight, leftHandCase: .bentDown, rightArmCase: .straight, rightHandCase: .bentDown, leftLegCase: .halfOpen, leftKneeCase: .bentOut, rightLegCase: .halfOpen, rightKneeCase: .bentOut),
        Pose(image: UIImage(named: "pose 4")!, leftArmCase: .straight, leftHandCase: .bentUpIn, rightArmCase: .straight, rightHandCase: .bentDownIn, leftLegCase: .Open, leftKneeCase: .bentIn, rightLegCase: .straight, rightKneeCase: .straight),
        Pose(image: UIImage(named: "pose 5")!, leftArmCase: .down, leftHandCase: .retoOutstretched, rightArmCase: .straight, rightHandCase: .bentUpIn, leftLegCase: .straight, leftKneeCase: .straight, rightLegCase: .Open, rightKneeCase: .bent),
        Pose(image: UIImage(named: "pose 6")!, leftArmCase: .straight, leftHandCase: .bentUpIn, rightArmCase: .straight, rightHandCase: .bentUpIn, leftLegCase: .halfOpen, leftKneeCase: .bentOut, rightLegCase: .halfOpen, rightKneeCase: .bentOut),
    ]
}
