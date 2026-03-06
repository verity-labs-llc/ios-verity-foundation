//
//  LoggingReducer.swift
//  Albumo
//
//  Created by BJ Beecher on 9/3/25.
//

import ComposableArchitecture

@Reducer
public struct LoggingReducer<State, Action> {
    @Dependency(\.loggingService) private var logger
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            logger.info("\(action)")
            return .none
        }
    }
}
