//
//  ChartPoint.swift
//  Charts
//
//  Created by Max Koriakin on 12/14/18.
//  Copyright © 2018 Max Koriakin. All rights reserved.
//

import UIKit

class ChartPoint: UIView {

    var coordinate: Coordinate?
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
