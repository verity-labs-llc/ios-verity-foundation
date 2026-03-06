//
//  StandardAsyncView.swift
//  Albumo
//
//  Created by BJ Beecher on 12/18/25.
//

import VLData
import SwiftUI

public struct StandardAsyncView<UI: DataAccessObject, Content: View>: View {
    let endpoint: DataAccessor<UI>
    let content: (Binding<UI>) -> Content
    
    public init(endpoint: DataAccessor<UI>, @ViewBuilder content: @escaping (Binding<UI>) -> Content) {
        self.endpoint = endpoint
        self.content = content
    }
    
    public init(endpoint: DataAccessor<UI>, @ViewBuilder content: @escaping (UI) -> Content) {
        self.endpoint = endpoint
        self.content = { content($0.wrappedValue) }
    }
    
    public var body: some View {
        AsyncView(endpoint: endpoint) { store in
            @Bindable var store = store
            
            switch store.loadState {
            case .idle, .loading:
                ProgressView()
            case .success:
                if let binding = Binding($store.value) {
                    content(binding)
                }
            case .failure:
                ContentUnavailableView(
                    "Unable to load content",
                    systemImage: "exclamationmark.icloud"
                )
            }
        }
    }
}

#Preview {
    StandardAsyncView(endpoint: .previewTodo) { $ui in
        Text(ui.count, format: .number)
        
        Button("something") {
            ui.count += 1
        }
    }
}
