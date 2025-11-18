//
//  ConvexClient.swift
//  atlas
//
//  Created by Maddisen Mohnsen on 11/18/25.
//

import ConvexMobile
import Foundation

let convexKey = Bundle.main.object(forInfoDictionaryKey: "CONVEX_DEPLOYMENT") as! String
let convex = ConvexClient(deploymentUrl: convexKey)
