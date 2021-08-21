import Foundation
import Logging

/// The Framework to establish a connection to Campus Dual.
public struct CampusDualConnecter {
    /// The matriculation number to access Campus Dual.
    var matriculation: String
    /// The hash value to authenticate against Campus Dual.
    var hash: String
    /// The URL of the Campus Dual instance.
    var url: URL
    
    let logger = Logger(label: "eu.jonasrichter.CampusDualKit.CampusDualConnector")
    
    /// Creates a connection to Campus Dual and checks credentials.
    /// - Parameters:
    ///   - matriculation: The matriculation number of the student.
    ///   - hash: The unique hash value used to authenticate agianst Campus Dual of the student.
    public init?(matriculation matr: String, hash ha: String) async {
        if await CampusDualConnecter.checkConnection(matriculation: matr, hash: ha, url: URL.endpoints.standardUrl) {
            self.matriculation = matr
            self.hash = ha
            self.url = URL.endpoints.standardUrl
            logger.info("CampusDual-Connection succesful")
        } else {
            logger.critical("Couldn't connect to CampusDual")
            return nil
        }
    }
    
    /// Creates a connection to custom Campus Dual instance and checks credentials.
    /// - Parameters:
    ///   - matriculation: The matriculation number of the student.
    ///   - hash: The unique hash value used to authenticate agianst Campus Dual of the student.
    ///   - url: The base URL of the Campus Dual instance.
    public init?(matriculation matr: String, hash ha: String, url customUrl: URL) async {
        if await CampusDualConnecter.checkConnection(matriculation: matr, hash: ha, url: customUrl) {
            self.matriculation = matr
            self.hash = ha
            self.url = customUrl
            logger.info("CampusDual-Connection succesful")
        } else {
            logger.critical("Couldn't connect to CampusDual")
            return nil
        }
    }
    
    // Checks wheter given credentials are working by trying to get the current credit points
    internal static func checkConnection(matriculation user: String, hash auth: String, url baseUrl: URL) async -> Bool {
        let requestUrl = URL(string: "/dash/getcp?user=\(user)&hash=\(auth)", relativeTo: baseUrl)!
        do {
            let (_, response) = try await URLSession.shared.data(from: requestUrl)
            let urlResponse = response as! HTTPURLResponse
            if urlResponse.statusCode == 200 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

internal extension URL {
    enum endpoints {
        static let standardUrl = URL(string: "https://selfservice.campus-dual.de")!
        static let schedule = URL(string: "/room/json", relativeTo: Self.standardUrl)!
        static let creditPoints = URL(string: "/dash/getcp", relativeTo: Self.standardUrl)!
    }
}
