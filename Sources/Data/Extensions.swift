//
//  Extensions.swift
//  AppFoundation
//
//  Created by BJ Beecher on 2/18/26.
//

import VLSharedModels

extension EmptyResponse: DataAccessObject {
    public static func == (lhs: EmptyResponse, rhs: EmptyResponse) -> Bool {
        true
    }
    
    static public let sample = EmptyResponse()
}
