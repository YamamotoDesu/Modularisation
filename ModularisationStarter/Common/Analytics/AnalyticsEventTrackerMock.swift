//
//  AnalyticsEventTrackerMock.swift
//  ModularisationStarter
//
//  Created by Emre Havan on 15.02.24.
//

import Foundation

final class AnalyticsEventTrackerMock: AnalyticsEventTracking {

    var trackedEvents = [AnalyticsEvent]()

    func trackEvent(_ event: AnalyticsEvent) {
        trackedEvents.append(event)
    }
}
