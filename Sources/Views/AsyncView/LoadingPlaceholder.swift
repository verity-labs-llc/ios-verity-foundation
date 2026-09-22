import SwiftUI

public extension EnvironmentValues {
    @Entry var loadingPlaceholder: AnyView?
}

public extension View {
    func loadingPlaceholder<Placeholder: View>(@ViewBuilder _ placeholder: () -> Placeholder) -> some View {
        environment(\.loadingPlaceholder, AnyView(placeholder()))
    }
}
