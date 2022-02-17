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
	
	public func getValue(proxy proxyId: Int, variable variableId: Int) async throws {
		//TODO: Rebuild the 2way-web-driver to be secure
//		guard let url = URL(string: "http://\(self.controllerIP):9000/") else {
		guard let url = URL(string: "http://\(self.controllerIP):9000/?command=get&proxyID=\(proxyId)&variableID=\(variableId)") else {
			print("Invalid url for \(proxyId), \(variableId)")
			return
		}
		
		let (data, response) = try await performRequest(with: url)
		
		print(data)
		print(response)
	}
	
	public func setValue(device proxyId: Int, variable variableId: Int, newValue: Double) async throws {
		//TODO: Rebuild the 2way-web-driver to be secure
		guard let url = URL(string: "http://\(self.controllerIP):9000/?command=set&proxyID=\(proxyId)&variableID=\(variableId)&newValue=\(newValue)") else {
			print("Invalid url for \(proxyId), \(variableId), \(newValue)")
			return
		}
		
		let (data, response) = try await performRequest(with: url)
		
		print(data)
		print(response)
	}
	
	public func rampValue(device proxyId: Int, variable variableId: Int, newValue: Double) async throws {
		//TODO: Rebuild the 2way-web-driver to be secure
		guard let url = URL(string: "http://\(self.controllerIP):9000/?command=ramp&proxyID=\(proxyId)&variableID=\(variableId)&newValue=\(newValue)") else {
			print("Invalid url for \(proxyId), \(variableId), \(newValue)")
			return
		}
		
		let (data, response) = try await performRequest(with: url)
		
		print(data)
		print(response)
	}
	
	private func performRequest(with url: URL) async throws -> ([String : Any], HTTPURLResponse) {
		let (data, response) = try await session.data(from: url)
		
		guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200, httpResponse.statusCode < 300 else {
			throw Control4Error("Invalid response received \(response)")
		}
		
		guard let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
			throw Control4Error("Could not deserialize fjson")
		}
		
		return (jsonData, httpResponse)
	}
}
