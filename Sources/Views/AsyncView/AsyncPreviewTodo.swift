//
//  AsyncPreviewTodo.swift
//  VerityLabsFoundation
//
//  Created by Codex on 3/5/26.
//

import Foundation
import VLData

public struct AsyncPreviewTodo: DataAccessObject {
    public let id: Int
    public var title: String
    public var completed: Bool
    public var count: Int

    public init(id: Int, title: String, completed: Bool, count: Int) {
        self.id = id
        self.title = title
        self.completed = completed
        self.count = count
    }

    public static let sample = AsyncPreviewTodo(
        id: 1,
        title: "Preview todo",
        completed: false,
        count: 0
    )
}

public extension DataAccessor where T == AsyncPreviewTodo {
    static let previewTodo = DataAccessor(
        endpoint: .init(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!),
        cacheId: "preview.async.todo.1"
    )
}
