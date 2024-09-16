//
//  AnalyticsEventTracking.swift
//  ModularisationStarter
//
//  Created by Emre Havan on 15.02.24.
//

import Foundation

protocol AnalyticsEventTracking {
    func trackEvent(_ event: AnalyticsEvent)
}
