//
//  File.swift
//  
//
//  Created by Joshua Tessier on 2022-02-24.
//

import Foundation

public struct Control4Scene: Identifiable, Codable {
    public let id: Int
    public let isActive: Bool
    public let name: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case isActive = "is_active"
        case id = "scene_id"
    }

    public init(id: Int, isActive: Bool, name: String) {
        self.id = id
        self.isActive = isActive
        self.name = name
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        isActive = try Bool(values.decode(String.self, forKey: .isActive)) ?? false
        id = try Int(values.decode(String.self, forKey: .id)) ?? -1
        name = try values.decode(String.self, forKey: .name)
    }
}

public struct ScenesResponse: Codable {
    let response: [Control4Scene]
    
    private enum CodingKeys: String, CodingKey {
        case response = "response"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        response = try values.decode(Array<Control4Scene>.self, forKey: .response)
    }
}
