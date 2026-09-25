//
//  Destination.swift
//  VerityLabsFoundation
//
//  Created by BJ Beecher on 4/23/26.
//

import SwiftUI

public protocol RouterDestination: Hashable, Identifiable, Sendable {
    var sheetDetents: Set<PresentationDetent>? { get }
}

public extension RouterDestination {
    var sheetDetents: Set<PresentationDetent>? { nil }
}
