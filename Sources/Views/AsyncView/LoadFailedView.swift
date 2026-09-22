import SwiftUI

public struct LoadFailedView: View {
    private let title: String
    private let retry: () async -> Void

    public init(_ title: String = "Something went wrong", retry: @escaping () async -> Void) {
        self.title = title
        self.retry = retry
    }

    public var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "exclamationmark.icloud")
        } description: {
            Text("Check your connection and try again.")
        } actions: {
            Button("Try Again", systemImage: "arrow.clockwise") {
                Task { await retry() }
            }
            .buttonStyle(.bordered)
        }
    }
}
