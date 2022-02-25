import Foundation

public enum Control4Error: LocalizedError {
    //400 style errors
    case noDataReceived(_ message: String)
    case malformedData(_ message: String)
    case noResponse(_ message: String)
    
    //500
    case serverError(_ message: String)
    
    //Other
    case unknown(_ message: String)
    
    public var errorDescription: String? {
        switch self {
        case let .noDataReceived(message):
            return "No data received: \(message)"
        case let .malformedData(message):
            return "Received malformed data: \(message)"
        case let .noResponse(message):
            return "Did not receive a response from the server: \(message)"
        case let .serverError(message):
            return "Server error: \(message)"
        case let .unknown(message):
            return "Unexpected error: \(message)"
        }
    }
}

public class Control4Controller: NSObject, URLSessionDelegate {
	private let session: URLSession
	let controllerIP: String
	
	public init(at controllerIP: String) {
		session = URLSession(configuration: .default)
		self.controllerIP = controllerIP
    }
    
    public func getScenes() async throws -> [Control4Scene] {
        let (data, _) = try await performRequest(urlRequest("GET", path: "scenes"))
        
        //TODO: Push this down to `performRequest` and provide `responseFormat`
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(ScenesResponse.self, from: data).response
        }
        catch {
            throw Control4Error.malformedData(error.localizedDescription)
        }
    }
    
    public func getScene(_ sceneId: Int) async throws {
        let (data, response) = try await performRequest(urlRequest("GET", path: "scene/\(sceneId)"))
        
        print(data)
        print(response)
    }
    
    public func activateScene(_ sceneId: Int) async throws {
        let (data, response) = try await performRequest(urlRequest("POST", path: "scene/\(sceneId)/activate"))
        
        print(data)
        print(response)
    }
    
    public func deactivateScene(_ sceneId: Int) async throws {
        let (data, response) = try await performRequest(urlRequest("POST", path: "scene/\(sceneId)/deactivate"))
        
        print(data)
        print(response)
    }
	
    private func urlRequest(_ method: String, path: String, body: Any? = nil) throws -> URLRequest {
        guard let url = URL(string: "http://\(self.controllerIP):9000/\(path)") else {
            throw Control4Error.noResponse("Invalid url for IP: \(self.controllerIP) and path \(path)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }
    
    private func performRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
		
		guard let httpResponse = response as? HTTPURLResponse else {
            throw Control4Error.serverError("Invalid response received \(response)")
		}
        
        if httpResponse.statusCode >= 500 {
            throw Control4Error.serverError("500 - Server Error")
        }
        else if httpResponse.statusCode == 404 {
            throw Control4Error.noResponse("404 - Not Found")
        }
        
        guard httpResponse.statusCode >= 200, httpResponse.statusCode < 300 else {
            throw Control4Error.unknown("Unexpected error: \(httpResponse.statusCode)")
        }
		
		return (data, httpResponse)
	}
}
