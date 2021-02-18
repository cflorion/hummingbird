import NIO

/// Applied to `HBRequest` before it is dealt with by the router. Middleware passes the processed request onto the next responder
/// (either the next middleware or the router) by calling `next.apply(to: request)`. If you want to shortcut the request you
/// can return a response immediately
///
/// Middleware is added to the application by calling `app.middleware.add(MyMiddleware()`.
///
/// Middleware allows you to process a request before it reaches your request handler and then process the response
/// returned by that handler.
/// ```
/// func apply(to request: HBRequest, next: HBResponder) async throws -> HBResponse {
///     let request = processRequest(request)
///     return next.respond(to: request).map { response in
///         return processResponse(response)
///     }
/// }
/// ```
/// Middleware also allows you to shortcut the whole process and not pass on the request to the handler
/// ```
/// func apply(to request: HBRequest, next: HBResponder) async throws -> HBResponse {
///     if request.method == .OPTIONS {
///         return request.success(HBResponse(status: .noContent))
///     } else {
///         return next.respond(to: request)
///     }
/// }
/// ```
public protocol HBMiddleware {
    func apply(to request: HBRequest, next: HBResponder) async throws -> HBResponse
}

struct MiddlewareResponder: HBResponder {
    let middleware: HBMiddleware
    let next: HBResponder

    func respond(to request: HBRequest) async throws -> HBResponse {
        return try await self.middleware.apply(to: request, next: self.next)
    }
}
