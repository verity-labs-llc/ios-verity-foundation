import Foundation
import SwiftUI

/// Fixed query states for previews. Successful and empty data still come from typed fixtures.
public enum QueryPreviewState: Sendable, Equatable {
    case loading
    case failure

    func snapshot<Value: Sendable>(key: QueryKey) -> QuerySnapshot<Value> {
        QuerySnapshot(
            key: key,
            status: self == .loading ? .pending : .failure,
            isFetching: self == .loading,
            data: nil,
            error: self == .failure ? QueryPreviewError.simulatedFailure : nil,
            updatedAt: nil,
            isStale: true
        )
    }
}

public enum QueryPreviewError: Error, Sendable, Equatable, LocalizedError {
    case simulatedFailure
    case loading

    public var errorDescription: String? {
        switch self {
        case .simulatedFailure: "Simulated query failure for preview."
        case .loading: "This preview holds queries in the loading state."
        }
    }
}

private struct QueryPreviewModifier: ViewModifier {
    @State private var client: QueryClient

    init(state: QueryPreviewState?) {
        _client = State(initialValue: QueryClient(previewState: state))
    }

    func body(content: Content) -> some View {
        content.queryClient(client)
    }
}

public extension View {
    /// Overrides all descendant queries without executing their fetch operations.
    /// Pass nil in a nested subtree to restore normal fetching with a separate client.
    func queryPreviewState(_ state: QueryPreviewState?) -> some View {
        modifier(QueryPreviewModifier(state: state))
            .id(state)
    }
}
