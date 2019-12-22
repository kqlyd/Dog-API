//
//  Reachability.swift
//  BreedApi
//
//  Created by Denis Zhukov on 17/12/2019.
//  Copyright © 2019 Denis Zhukov. All rights reserved.
//

import Foundation
import ResourceNetworking


class FakeReachability: ReachabilityProtocol {
    var isReachable: Bool
    
    init(isReachable: Bool) {
        self.isReachable = isReachable
    }
}
