//
//  URLSession+scheduleServiceDataTask.swift
//  
//
//  Created by Jonas Richard Richter on 22.01.22.
//

import Foundation

internal extension URLSession {
    
    func scheduleServiceDataTask<T: Decodable>(request: URLRequest, session: URLSession, completion: @escaping (Result<T, ScheduleServiceError>) -> Void) {
        
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(.failure(.network(error)))
                return
            }
            
            guard let _ = response, let data = data else {
                completion(.failure(.network(nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // All dates are stored as secondsSince1970
                decoder.dateDecodingStrategy = .secondsSince1970
                
                let decoded = try decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decoding(error)))
                return
            }
        }
        
        task.resume()
        
    }
}
