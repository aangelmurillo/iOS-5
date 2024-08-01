//
//  Models.swift
//  OCTAVIO_QUINTO
//
//  Created by Adrian Gottfried on 31/07/24.
//

import Foundation

struct LoginResponse: Codable {
    let token: Token
}

struct Token: Codable {
    let type: String
    let token: String
}

struct Role: Codable {
    let id: Int
    let rol_name: String
    let rol_slug: String
    let created_at: String
    let updated_at: String
}

struct Helmet: Codable {
    let id: Int
    let helmet_serial_number: String
    let created_at: String
    let updated_at: String
}

struct Address: Codable {
    let id: Int
    let address_street: String
    let address_exterior_number: String
    let address_interior_number: String
    let address_neighborhood: String
    let address_zip_code: String
    let address_city: String
    let address_state: String
    let address_country: String
    let person_id: Int
    let created_at: String
    let updated_at: String
}

struct Person: Codable {
    let id: Int
    let person_name: String
    let person_last_name: String
    let person_second_last_name: String
    let person_curp: String
    let person_phone_number: String
    let created_at: String
    let updated_at: String
    let addresses: [Address]
}

struct User: Codable {
    let id: Int
    let user_name: String
    let email: String
    let rol_id: Int
    let person_id: Int
    let helmet_id: Int
    let remember_me_token: String
    let verification_code: String?
    let verificate: Int
    let created_at: String
    let updated_at: String
    let rol: Role
    let helmet: Helmet
    let person: Person
}

// Ya no necesitas la estructura UserInfoResponse.
