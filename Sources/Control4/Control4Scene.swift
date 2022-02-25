//
//  File.swift
//  
//
//  Created by Joshua Tessier on 2022-02-24.
//

import Foundation

public struct Control4Scene: Codable {
    let isActive: Bool
    let sceneId: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case isActive = "is_active"
        case sceneId = "scene_id"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        isActive = try Bool(values.decode(String.self, forKey: .isActive)) ?? false
        sceneId = try Int(values.decode(String.self, forKey: .sceneId)) ?? -1
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
