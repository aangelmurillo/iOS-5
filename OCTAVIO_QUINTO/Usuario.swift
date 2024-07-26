//
//  Usuario.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 26/07/24.
//

import UIKit

class Usuario: Codable {
    var id: Int?
    var userName: String
    var email: String
    var password: String
    var rolId: Int?
    var personId: Int?
    var helmetId: Int?
    var rememberMeToken: String?
    var verificationCode: String?
    var verificate: Int
    var createdAt: Date?
    var updatedAt: Date?
    
    init(id: Int? = nil, userName: String, email: String, password: String, rolId: Int? = nil, personId: Int? = nil, helmetId: Int? = nil, rememberMeToken: String? = nil, verificationCode: String? = nil, verificate: Int = 0, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.userName = userName
        self.email = email
        self.password = password
        self.rolId = rolId
        self.personId = personId
        self.helmetId = helmetId
        self.rememberMeToken = rememberMeToken
        self.verificationCode = verificationCode
        self.verificate = verificate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
