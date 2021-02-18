import Hummingbird
import HummingbirdXCT
import XCTest

final class RouterTests: XCTestCase {
    struct TestMiddleware: HBMiddleware {
        func apply(to request: HBRequest, next: HBResponder) async throws -> HBResponse {
            let response = try await next.respond(to: request)
            response.headers.replaceOrAdd(name: "middleware", value: "TestMiddleware")
            return response
        }
    }

    func testEndpoint() {
        let app = HBApplication(testing: .live)
        app.router
            .group("/endpoint")
            .get { _ in
                return "GET"
            }
            .put { _ in
                return "PUT"
            }
        app.XCTStart()
        defer { app.XCTStop() }

        app.XCTExecute(uri: "/endpoint", method: .GET) { response in
            let body = try XCTUnwrap(response.body)
            XCTAssertEqual(String(buffer: body), "GET")
        }

        app.XCTExecute(uri: "/endpoint", method: .PUT) { response in
            let body = try XCTUnwrap(response.body)
            XCTAssertEqual(String(buffer: body), "PUT")
        }
    }

    func testGroupMiddleware() {
        let app = HBApplication(testing: .live)
        app.router
            .group()
            .add(middleware: TestMiddleware())
            .get("/group") { _ in
                return "hello"
            }
        app.router.get("/not-group") { _ in
            return "hello"
        }
        app.XCTStart()
        defer { app.XCTStop() }

        app.XCTExecute(uri: "/group", method: .GET) { response in
            XCTAssertEqual(response.headers["middleware"].first, "TestMiddleware")
        }

        app.XCTExecute(uri: "/not-group", method: .GET) { response in
            XCTAssertEqual(response.headers["middleware"].first, nil)
        }
    }

    func testEndpointMiddleware() {
        let app = HBApplication(testing: .live)
        app.router
            .group("/group")
            .add(middleware: TestMiddleware())
            .head { _ in
                return "hello"
            }
        app.XCTStart()
        defer { app.XCTStop() }

        app.XCTExecute(uri: "/group", method: .HEAD) { response in
            XCTAssertEqual(response.headers["middleware"].first, "TestMiddleware")
        }
    }

    func testGroupGroupMiddleware() {
        let app = HBApplication(testing: .live)
        app.router
            .group("/test")
            .add(middleware: TestMiddleware())
            .group("/group")
            .get { request in
                return request.success("hello")
            }
        app.XCTStart()
        defer { app.XCTStop() }

        app.XCTExecute(uri: "/test/group", method: .GET) { response in
            XCTAssertEqual(response.headers["middleware"].first, "TestMiddleware")
        }
    }

    func testParameters() {
        let app = HBApplication(testing: .live)
        app.router
            .delete("/user/:id") { request -> String? in
                return request.parameters.get("id", as: String.self)
            }
        app.XCTStart()
        defer { app.XCTStop() }

        app.XCTExecute(uri: "/user/1234", method: .DELETE) { response in
            let body = try XCTUnwrap(response.body)
            XCTAssertEqual(String(buffer: body), "1234")
        }
    }
}
