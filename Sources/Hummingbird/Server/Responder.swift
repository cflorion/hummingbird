import NIO

/// Protocol for object that produces a response given a request
///
/// This is the core protocol for Hummingbird. It defines an object that can respond to a request.
public protocol HBResponder {
    /// Return EventLoopFuture that will be fulfilled with response to the request supplied
    func respond(to request: HBRequest) async throws -> HBResponse
}

/// Responder that calls supplied closure
public struct HBCallbackResponder: HBResponder {
    let callback: (HBRequest) async throws -> HBResponse

    public init(callback: @escaping (HBRequest) async throws -> HBResponse) {
        self.callback = callback
    }

    /// Return EventLoopFuture that will be fulfilled with response to the request supplied
    public func respond(to request: HBRequest) async throws -> HBResponse {
        return try await self.callback(request)
    }
}
