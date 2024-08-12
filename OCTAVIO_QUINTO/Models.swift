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
    let address_interior_number: String?
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

struct PersonRequestBody: Codable {
    let person_name: String
    let person_last_name: String
    let person_second_last_name: String
    let person_curp: String
    let person_phone_number: String
}

struct PersonResponse: Codable {
    let id: Int
    let person_name: String
    let person_last_name: String
    let person_second_last_name: String
    let person_curp: String
    let person_phone_number: String
    let created_at: String
    let updated_at: String
}


struct User: Codable {
    let id: Int
    let user_name: String
    let email: String
    let rol_id: Int
    let person_id: Int
    let helmet_id: Int?
    let remember_me_token: String?
    let verification_code: String?
    let verificate: Int
    let created_at: String
    let updated_at: String
    let helmet: Helmet?
    let person: Person
}

struct SensorData: Codable {
    let helmet_id: String
    let sensor: String
    let latest_value: Double
    let timestamp: String
}

// ---

struct UserResponse: Codable {
    let id: Int
    let user_name: String
    let email: String
    let rol_id: Int
    let person_id: Int
    let helmet_id: Int?
    let remember_me_token: String?
    let verification_code: String?
    let verificate: Int
    let created_at: String
    let updated_at: String
    let rol: Role
    let person: PersonResponse
    let helmet: Helmet?
}

// ---

struct PersonalHelmetStatsResponse: Codable {
    let status: String
    let data: Stats
}

struct Stats: Codable {
    let temperatura: StatDetail
    let presion: StatDetail
    let altitud: StatDetail
    let humedad: StatDetail
    let hscr_04: StatDetail
    let mq2: StatDetail
    let mq135: StatDetail
    let fc28: StatDetail
}

struct StatDetail: Codable {
    let max: Double?
    let min: Double?
    
    private enum CodingKeys: String, CodingKey {
        case max
        case min
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let maxString = try? container.decode(String.self, forKey: .max) {
            max = Double(maxString)
        } else {
            max = try? container.decode(Double.self, forKey: .max)
        }
        if let minString = try? container.decode(String.self, forKey: .min) {
            min = Double(minString)
        } else {
            min = try? container.decode(Double.self, forKey: .min)
        }
    }
}

struct ErrorResponse: Decodable {
    let message: String
}



