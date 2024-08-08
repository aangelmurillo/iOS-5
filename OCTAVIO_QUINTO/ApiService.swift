import Foundation

class ApiService {
    static let shared = ApiService() // Instancia compartida
    
    private init() {}
    
    // Mandar correo con código de recuperación
    func sendPasswordCode(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "http://3.138.244.45/password-code")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(CustomError(message: "No se recibió una respuesta válida del servidor.")))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let serverError = CustomError(message: "Error del servidor con código de estado: \(httpResponse.statusCode)", response: httpResponse)
                completion(.failure(serverError))
                return
            }
            
            if let data = data, let responseMessage = String(data: data, encoding: .utf8) {
                completion(.success(responseMessage))
            } else {
                completion(.failure(CustomError(message: "Datos de respuesta inválidos del servidor.")))
            }
        }
        
        task.resume()
    }

    // Actualizar contraseña
    func updatePassword(email: String, newPassword: String, verificationCode: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "http://3.138.244.45/password-update")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["email": email, "new-password": newPassword, "verification-code": verificationCode]
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
                let errorMessage = "Error en la solicitud: \(httpResponse.statusCode)"
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

            // Imprime los datos crudos para depuración
            if let rawData = String(data: data, encoding: .utf8) {
                print("Datos crudos de la respuesta: \(rawData)")
            }

            // Asume que la respuesta es una cadena simple
            let responseMessage = String(data: data, encoding: .utf8) ?? "Respuesta vacía"
            completion(.success(responseMessage))
        }
        task.resume()
    }
    
    // Método para verificar el código de verificación
    func verifyCode(email: String, verificationCode: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "http://3.138.244.45/password-verify")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email, "verification_code": verificationCode]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(CustomError(message: "No se recibió una respuesta válida del servidor.")))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let serverError = CustomError(message: "Error del servidor con código de estado: \(httpResponse.statusCode)", response: httpResponse)
                completion(.failure(serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(CustomError(message: "Datos de respuesta vacíos del servidor.")))
                return
            }
            
            do {
                // Decodifica la respuesta JSON
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = jsonResponse["message"] as? String {
                    completion(.success(message))
                } else {
                    completion(.failure(CustomError(message: "Formato de respuesta JSON inválido.")))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    
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
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Datos de respuesta vacíos (FetchUserInfo)"])))
                return
            }
            
            // Imprime los datos recibidos para depuración
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Datos recibidos (FetchUserInfo): \(jsonString)")
            }

            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                print("Error al decodificar usuarios: \(error)") // Depura errores de decodificación
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // Método para obtener todos los usuarios (exceptuando admin)
    func fetchAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
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
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Datos de respuesta vacíos (FetchAllUsers)"])))
                return
            }
            
            // Imprime los datos recibidos para depuración
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Datos recibidos (FetchAllUsers): \(jsonString)")
            }

            do {
                let decoder = JSONDecoder()
                let users = try decoder.decode([User].self, from: data)
                print("Usuarios decodificados: \(users)") // Verifica los usuarios decodificados
                completion(.success(users))
            } catch {
                print("Error al decodificar usuarios: \(error)") // Depura errores de decodificación
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchSensorData(helmetId: String, sensorType: String, completion: @escaping (Result<SensorData, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token de autenticación no encontrado"])))
            return
        }
        
        let url = URL(string: "http://3.138.244.45/helmets/sensor-data")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = ["helmet_id": helmetId, "sensor_type": sensorType]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let errorMessage = "Respuesta no válida"
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                print(errorMessage)
                completion(.failure(error))
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode != 200 {
                let errorMessage = "Error en la solicitud. Código de estado: \(httpResponse.statusCode)"
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Respuesta del servidor: \(responseString)")
                }
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Datos de respuesta vacíos (FetchSensorData)"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let sensorData = try decoder.decode(SensorData.self, from: data)
                completion(.success(sensorData))
            } catch {
                print("Error al decodificar los datos: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

// Estructura de error personalizada
struct CustomError: Error {
    let message: String
    let response: HTTPURLResponse?
    
    init(message: String, response: HTTPURLResponse? = nil) {
        self.message = message
        self.response = response
    }
}

