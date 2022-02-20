import Foundation

public struct Control4Error: Error {
	let message: String
	
	init(_ message: String) {
		self.message = message
	}
}

public class Control4Controller: NSObject, URLSessionDelegate {
	private let session: URLSession
	let controllerIP: String
	
	public init(at controllerIP: String) {
		session = URLSession(configuration: .default)
		self.controllerIP = controllerIP
    }
    
    public func getScenes() async throws {
        let (data, response) = try await performRequest(urlRequest("GET", path: "scenes"))
        
        print(data)
        print(response)
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
            throw Control4Error("Invalid url for IP: \(self.controllerIP) and path \(path)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let httpBody = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: httpBody, options: [])
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }
    
    private func performRequest(_ request: URLRequest) async throws -> ([String : Any], HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
		
		guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200, httpResponse.statusCode < 300 else {
			throw Control4Error("Invalid response received \(response)")
		}
		
		guard let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
			throw Control4Error("Could not deserialize fjson")
		}
		
		return (jsonData, httpResponse)
	}
}
