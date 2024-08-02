//
//  MockModel.swift
//  InterviewProjectTests
//
//  Created by Cameron Taylor on 8/2/24.
//

import Foundation

struct MockModelPerson: Codable {
    var firstName: String
    var lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
