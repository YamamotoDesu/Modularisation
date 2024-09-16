//
//  String+localised.swift
//  ModularisationStarter
//
//  Created by Emre Havan on 14.02.24.
//

import Foundation

extension String {
    
    var localised: String {
        NSLocalizedString(self, comment: "")
    }
}
