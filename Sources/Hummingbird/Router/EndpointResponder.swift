import NIO
import NIOHTTP1

/// Responder that chooses the next responder to call based on the request method
class HBEndpointResponder: HBResponder {
    init() {
        self.methods = [:]
    }

    public func respond(to request: HBRequest) async throws -> HBResponse {
        guard let responder = methods[request.method.rawValue] else {
            throw HBHTTPError(.notFound)
        }
        return try await responder.respond(to: request)
    }

    func addResponder(for method: HTTPMethod, responder: HBResponder) {
        guard self.methods[method.rawValue] == nil else {
            preconditionFailure("\(method.rawValue) already has a handler")
        }
        self.methods[method.rawValue] = responder
    }

    var methods: [String: HBResponder]
}
