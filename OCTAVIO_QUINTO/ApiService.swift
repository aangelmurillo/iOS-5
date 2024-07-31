import Foundation

class ApiService {
    static let shared = ApiService()
    
    private init() {}
    
    func getUserInfo(userId: Int, completion: @escaping (Result<Usuario, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "No token found", code: 401, userInfo: nil)))
            return
        }
        
        let url = URL(string: "http://3.138.244.45/users/\(userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 400, userInfo: nil)))
                return
            }
            
            do {
                let usuario = try JSONDecoder().decode(Usuario.self, from: data)
                completion(.success(usuario))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
