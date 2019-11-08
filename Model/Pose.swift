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
    let leftArmCase : ShoulderToForearmSubcase
    let leftHandCase: ForearmToHandSubcase
    
    let rightArmCase : ShoulderToForearmSubcase
    let rightHandCase: ForearmToHandSubcase
    
    let leftLegCase : LegToKneeSubcase
    let leftKneeCase: KneeToFootCase
    
    let rightLegCase : LegToKneeSubcase
    let rightKneeCase: KneeToFootCase
}


class Forms {
    static var shared = Forms()

    let Poses = [
        Pose(image: UIImage(named: "form")!, leftArmCase: .downStraight, leftHandCase: .retoOutstretched, rightArmCase: .upStraight, rightHandCase: .retoOutstretched, leftLegCase: .straightReto, leftKneeCase: .straight, rightLegCase: .straightReto, rightKneeCase: .straight),
    ]
}
