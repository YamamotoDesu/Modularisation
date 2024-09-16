//
//  AnalyticsEvent.swift
//  ModularisationStarter
//
//  Created by Emre Havan on 15.02.24.
//

import Foundation

struct AnalyticsEvent {

    let name: String
    let parameters: [String: Any]?

    init(name: String, parameters: [String : Any]? = nil) {
        self.name = name
        self.parameters = parameters
    }
}
