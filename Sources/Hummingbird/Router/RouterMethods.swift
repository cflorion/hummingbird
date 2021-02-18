import NIO
import NIOHTTP1

public protocol HBRouterMethods {
    /// Add path for closure returning type conforming to ResponseFutureEncodable
    @discardableResult func on<R: HBResponseGenerator>(_ path: String, method: HTTPMethod, use: @escaping (HBRequest) throws -> R) -> Self
    /// Add path for closure returning type conforming to ResponseEncodable
    @discardableResult func on<R: HBResponseGenerator>(_ path: String, method: HTTPMethod, use: @escaping (HBRequest) async throws -> R) -> Self
}

extension HBRouterMethods {
    /// GET path for closure returning type conforming to HBResponseGenerator
    @discardableResult public func get<R: HBResponseGenerator>(_ path: String = "", use closure: @escaping (HBRequest) async throws -> R) -> Self {
        return on(path, method: .GET, use: closure)
    }

    /// PUT path for closure returning type conforming to HBResponseGenerator
    @discardableResult public func put<R: HBResponseGenerator>(_ path: String = "", use closure: @escaping (HBRequest) async throws -> R) -> Self {
        return on(path, method: .PUT, use: closure)
    }

    /// POST path for closure returning type conforming to HBResponseGenerator
    @discardableResult public func post<R: HBResponseGenerator>(_ path: String = "", use closure: @escaping (HBRequest) async throws -> R) -> Self {
        return on(path, method: .POST, use: closure)
    }

    /// HEAD path for closure returning type conforming to HBResponseGenerator
    @discardableResult public func head<R: HBResponseGenerator>(_ path: String = "", use closure: @escaping (HBRequest) async throws -> R) -> Self {
        return on(path, method: .HEAD, use: closure)
    }

    /// DELETE path for closure returning type conforming to HBResponseGenerator
    @discardableResult public func delete<R: HBResponseGenerator>(_ path: String = "", use closure: @escaping (HBRequest) async throws -> R) -> Self {
        return on(path, method: .DELETE, use: closure)
    }

    /// PATCH path for closure returning type conforming to HBResponseGenerator
    @discardableResult public func patch<R: HBResponseGenerator>(_ path: String = "", use closure: @escaping (HBRequest) async throws -> R) -> Self {
        return on(path, method: .PATCH, use: closure)
    }

    /// GET path for closure returning type conforming to HBResponseGenerator
    @discardableResult public func get<R: HBResponseGenerator>(_ path: String = "", use closure: @escaping (HBRequest) throws -> R) -> Self {
        return on(path, method: .GET, use: closure)
    }

    /// PUT path for closure returning type conforming to HBResponseGenerator
    @discardableResult public func put<R: HBResponseGenerator>(_ path: String = "", use closure: @escaping (HBRequest) throws -> R) -> Self {
        return on(path, method: .PUT, use: closure)
    }

    /// POST path for closure returning type conforming to HBResponseGenerator
    @discardableResult public func post<R: HBResponseGenerator>(_ path: String = "", use closure: @escaping (HBRequest) throws -> R) -> Self {
        return on(path, method: .POST, use: closure)
    }

    /// HEAD path for closure returning type conforming to HBResponseGenerator
    @discardableResult public func head<R: HBResponseGenerator>(_ path: String = "", use closure: @escaping (HBRequest) throws -> R) -> Self {
        return on(path, method: .HEAD, use: closure)
    }

    /// DELETE path for closure returning type conforming to HBResponseGenerator
    @discardableResult public func delete<R: HBResponseGenerator>(_ path: String = "", use closure: @escaping (HBRequest) throws -> R) -> Self {
        return on(path, method: .DELETE, use: closure)
    }

    /// PATCH path for closure returning type conforming to HBResponseGenerator
    @discardableResult public func patch<R: HBResponseGenerator>(_ path: String = "", use closure: @escaping (HBRequest) throws -> R) -> Self {
        return on(path, method: .PATCH, use: closure)
    }
}
