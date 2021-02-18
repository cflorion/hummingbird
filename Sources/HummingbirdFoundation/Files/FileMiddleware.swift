#if os(Linux)
import Glibc
#else
import Darwin.C
#endif
import Foundation
import Hummingbird
import NIO

public struct HBFileMiddleware: HBMiddleware {
    let rootFolder: String
    let fileIO: HBFileIO

    public init(_ rootFolder: String = "public", application: HBApplication) {
        var rootFolder = rootFolder
        if rootFolder.last == "/" {
            rootFolder = String(rootFolder.dropLast())
        }
        self.rootFolder = rootFolder
        self.fileIO = .init(application: application)

        let workingFolder: String
        if rootFolder.first == "/" {
            workingFolder = rootFolder
        } else {
            if let cwd = getcwd(nil, Int(PATH_MAX)) {
                workingFolder = String(cString: cwd)
                free(cwd)
            } else {
                workingFolder = "."
            }
        }
        application.logger.info("FileMiddleware serving from \(workingFolder)/\(rootFolder)")
    }

    public func apply(to request: HBRequest, next: HBResponder) async throws -> HBResponse {
        // if next responder returns a 404 then check if file exists
        do {
            return try await next.respond(to: request)
        } catch {
            guard let httpError = error as? HBHTTPError, httpError.status == .notFound else {
                throw error
            }

            guard let path = request.uri.path.removingPercentEncoding else {
                throw HBHTTPError(.badRequest)
            }

            guard !path.contains("..") else {
                throw HBHTTPError(.badRequest)
            }

            let fullPath = rootFolder + path

            switch request.method {
            case .GET:
                let body = try await fileIO.loadFile(path: fullPath, context: request.context)
                return HBResponse(status: .ok, body: body)

            case .HEAD:
                return try await fileIO.headFile(path: fullPath, context: request.context)

            default:
                throw error
            }
        }
    }
}
