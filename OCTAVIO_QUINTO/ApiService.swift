import Foundation

class ApiService {
    static let shared = ApiService() // Instancia compartida
    
    private init() {}
    
    // Método para manejar el login
    func login(user: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "http://3.138.244.45/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["user": user, "password": password]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Respuesta inesperada del servidor."])))
                return
            }

            if httpResponse.statusCode != 200 {
                let errorMessage = "Error de autenticación: \(httpResponse.statusCode)"
                if let data = data {
                    let errorData = String(data: data, encoding: .utf8) ?? "Datos vacíos"
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "\(errorMessage). Datos de error: \(errorData)"])))
                } else {
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Datos de respuesta vacíos."])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                let token = loginResponse.token.token
                UserDefaults.standard.set(token, forKey: "authToken")
                completion(.success(token))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // Método para obtener la información del usuario
    func fetchUserInfo(completion: @escaping (Result<User, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("Token de autenticación no encontrado")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token de autenticación no encontrado"])))
            return
        }
        
        let url = URL(string: "http://3.138.244.45/users/info")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let errorMessage = "Error en la solicitud"
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Datos de respuesta vacíos"])))
                return
            }
            
            // Imprime los datos recibidos para depuración
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Datos recibidos: \(jsonString)")
            }

            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // Método para obtener todos los usuarios (exceptuando admin)
    func fetchAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("Token de autenticación no encontrado")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token de autenticación no encontrado"])))
            return
        }
        
        let url = URL(string: "http://3.138.244.45/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let errorMessage = "Error en la solicitud"
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Datos de respuesta vacíos"])))
                return
            }
            
            // Imprime los datos recibidos para depuración
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Datos recibidos: \(jsonString)")
            }

            do {
                // Decodifica la respuesta como un arreglo de usuarios
                let decoder = JSONDecoder()
                let users = try decoder.decode([User].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

}
