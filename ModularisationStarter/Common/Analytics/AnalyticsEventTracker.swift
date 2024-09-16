//
//  AnalyticsEventTracker.swift
//  ModularisationStarter
//
//  Created by Emre Havan on 14.02.24.
//

import Foundation

final class AnalyticsEventTracker: AnalyticsEventTracking {

    static let shared = AnalyticsEventTracker()

    private init() {
        
    }
    
    func trackEvent(_ event: AnalyticsEvent) {
        // Call analytics 3rd party framework or your own implementation to track an event
    }
}
