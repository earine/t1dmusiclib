//
//  ChartsAction.swift
//  musiclib
//
//  Created by mlunts on 21.03.2022.
//

import Foundation

enum ChartsAction {
    case onAppear
    case dataLoaded(Result<Chart, APIError>)
}
