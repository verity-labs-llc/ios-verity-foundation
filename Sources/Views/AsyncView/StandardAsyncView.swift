import SwiftUI
import VLQuery

public struct StandardAsyncView<Value: Codable & Sendable, Content: View>: View {
    @Environment(\.queryClient) private var queryClient
    @Environment(\.loadingPlaceholder) private var loadingPlaceholder

    private let fetch: Fetch<Value>
    private let content: (Binding<Value>) -> Content

    public init(
        fetch: Fetch<Value>,
        @ViewBuilder content: @escaping (Binding<Value>) -> Content
    ) {
        self.fetch = fetch
        self.content = content
    }

    public init(
        fetch: Fetch<Value>,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.fetch = fetch
        self.content = { content($0.wrappedValue) }
    }

    public var body: some View {
        QueryView(fetch) { query in
            switch query.status {
            case .pending:
                if let loadingPlaceholder {
                    loadingPlaceholder
                } else {
                    ProgressView()
                        .tint(.secondary)
                }
            case .success:
                if let value = query.data {
                    content(
                        Binding(
                            get: { value },
                            set: { value in
                                Task {
                                    await queryClient.setQueryData(key: fetch.key, value)
                                }
                            }
                        )
                    )
                    .environment(\.loadingPlaceholder, nil)
                }
            case .failure:
                LoadFailedView("Unable to load content") {
                    await queryClient.invalidateQueries(
                        matching: QueryFilter(key: fetch.key, exact: true)
                    )
                }
            }
        }
    }
}

#Preview {
    StandardAsyncView(fetch: .previewTodo) { $todo in
        Text(todo.count, format: .number)

        Button("Update") {
            todo.count += 1
        }
    }
}
