import Kingfisher
import SwiftUI

public struct VLRemoteImage<RequestModifier: AsyncImageDownloadRequestModifier, Placeholder: View, Failure: View>: View {
    let url: URL?
    let cacheKey: String?
    let contentMode: SwiftUI.ContentMode
    let requestModifier: RequestModifier

    private let placeholderContent: () -> Placeholder
    private let failureContent: () -> Failure

    @Environment(\.displayScale) private var scale

    public var body: some View {
        GeometryReader { proxy in
            image(size: proxy.size)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    public func placeholder<Content: View>(
        @ViewBuilder _ content: @escaping () -> Content
    ) -> VLRemoteImage<RequestModifier, Content, Failure> {
        VLRemoteImage<RequestModifier, Content, Failure>(
            url: url,
            cacheKey: cacheKey,
            contentMode: contentMode,
            requestModifier: requestModifier,
            placeholderContent: content,
            failureContent: failureContent
        )
    }

    public func failureView<Content: View>(
        @ViewBuilder _ content: @escaping () -> Content
    ) -> VLRemoteImage<RequestModifier, Placeholder, Content> {
        VLRemoteImage<RequestModifier, Placeholder, Content>(
            url: url,
            cacheKey: cacheKey,
            contentMode: contentMode,
            requestModifier: requestModifier,
            placeholderContent: placeholderContent,
            failureContent: content
        )
    }

    init(
        url: URL?,
        cacheKey: String?,
        contentMode: SwiftUI.ContentMode,
        requestModifier: RequestModifier,
        placeholderContent: @escaping () -> Placeholder,
        failureContent: @escaping () -> Failure
    ) {
        self.url = url
        self.cacheKey = cacheKey
        self.contentMode = contentMode
        self.requestModifier = requestModifier
        self.placeholderContent = placeholderContent
        self.failureContent = failureContent
    }

    @ViewBuilder
    private func image(size: CGSize) -> some View {
        if let url {
            KFImage.url(url, cacheKey: cacheKey)
                .cacheOriginalImage()
                .requestModifier(requestModifier)
                .loadDiskFileSynchronously()
                .backgroundDecode()
                .setProcessor(DownsamplingImageProcessor(size: downsamplingSize(for: size)))
                .fade(duration: 0.2)
                .resizable()
                .onFailureView { failureContent() }
                .placeholder { placeholderContent() }
                .aspectRatio(contentMode: contentMode)
                .frame(width: size.width, height: size.height)
                .clipped()
                .contentShape(Rectangle())
        } else {
            placeholderContent()
                .frame(width: size.width, height: size.height)
                .contentShape(Rectangle())
        }
    }

    private func downsamplingSize(for size: CGSize) -> CGSize {
        let longestSide = max(size.width, size.height, 1) * scale
        let target = contentMode == .fill ? longestSide * 1.34 : longestSide
        let bucket = Self.sizeBuckets.first { $0 >= target } ?? Self.sizeBuckets.last!
        return CGSize(width: bucket, height: bucket)
    }

    private static var sizeBuckets: [CGFloat] { [200, 400, 800, 1200, 1600, 2400] }
}

public extension VLRemoteImage where Placeholder == EmptyView, Failure == EmptyView {
    init(
        url: URL?,
        cacheKey: String? = nil,
        contentMode: SwiftUI.ContentMode = .fill,
        requestModifier: RequestModifier
    ) {
        self.init(
            url: url,
            cacheKey: cacheKey,
            contentMode: contentMode,
            requestModifier: requestModifier,
            placeholderContent: { EmptyView() },
            failureContent: { EmptyView() }
        )
    }
}
