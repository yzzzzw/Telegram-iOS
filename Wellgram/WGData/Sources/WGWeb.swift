import Foundation

public func ngAPIsetDefaults() {
    let UD = UserDefaults(suiteName: "NGAPISETTINGS")
    UD?.register(defaults: ["SYNC_CHATS": false])
    UD?.register(defaults: ["RESTRICED": []])
    UD?.register(defaults: ["RESTRICTION_REASONS": []])
    UD?.register(defaults: ["ALLOWED": []])
}

public class NGAPISETTINGS {
    let UD = UserDefaults(suiteName: "NGAPISETTINGS")
    
    public init() {
        ngAPIsetDefaults()
    }
    
    public var SYNC_CHATS: Bool {
        get {
            return UD?.bool(forKey: "SYNC_CHATS") ?? false
        }
        set {
            UD?.set(newValue, forKey: "SYNC_CHATS")
        }
    }
    
    
    public var RESTRICTED: [Int64] {
        get {
            return UD?.array(forKey: "RESTRICTED") as? [Int64] ?? []
        }
        set {
            UD?.set(newValue, forKey: "RESTRICTED")
        }
    }
    
    public var RESTRICTION_REASONS: [String] {
        get {
            return UD?.array(forKey: "RESTRICTION_REASONS") as? [String] ?? []
        }
        set {
            UD?.set(newValue, forKey: "RESTRICTION_REASONS")
        }
    }
    
    public var ALLOWED: [Int64] {
        get {
            return UD?.array(forKey: "ALLOWED") as? [Int64] ?? []
        }
        set {
            UD?.set(newValue, forKey: "ALLOWED")
        }
    }
    
}
public var VARNGAPISETTINGS = NGAPISETTINGS()


extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                NSLog("\(String(data: data, encoding: .utf8))" + error.localizedDescription)
            }
        }
        return nil
    }
}

public func requestApi(_ path: String, pathParams: [String] = [], completion: @escaping (_ apiResult: [String: Any]?) -> Void) {
    let startTime = CFAbsoluteTimeGetCurrent()
    var urlString = "https://raw.githubusercontent.com/" + WGRepository + "/" + path + "/"
    for param in pathParams {
        urlString = urlString + String(param) + "/"
    }
    let url = URL(string: urlString)!
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        if let error = error {
            NSLog("Error requesting settings: \(error)")
        } else {
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        completion(dataString.convertToDictionary())
                    }
                }
            }
        }
    }
    task.resume()
}

public func getNGSettings(_ userId: Int64, completion: @escaping (_ sync: Bool, _ rreasons: [String], _ allowed: [Int64], _ restricted: [Int64], _ betaPremiumStatus: Bool) -> Void) {
    requestApi("settings", pathParams: [String(userId)], completion: { (apiResponse) -> Void in
        var syncChats = VARNGAPISETTINGS.SYNC_CHATS
        var restricitionReasons = VARNGAPISETTINGS.RESTRICTION_REASONS
        var allowedChats = VARNGAPISETTINGS.ALLOWED
        var restrictedChats = VARNGAPISETTINGS.RESTRICTED
        
        if let response = apiResponse {
            if let settings = response["settings"] {
                if  let syncSettings = (settings as! [String: Any])["sync_chats"] {
                    syncChats = syncSettings as! Bool
                }
            }
            
            if let reasons = response["reasons"] {
                restricitionReasons = reasons as! [String]
            }
            
            if let allowed = response["allowed"] {
                allowedChats = allowed as! [Int64]
            }
            
            if let restricted = response["restricted"] {
                restrictedChats = restricted as! [Int64]
            }
            
        }
        completion(syncChats, restricitionReasons, allowedChats, restrictedChats, false)
    })
}

public func updateNGInfo(userId: Int64) {
    getNGSettings(userId, completion: { (sync, rreasons, allowed, restricted, isBetaPremium) -> Void in
        VARNGAPISETTINGS.SYNC_CHATS = sync
        VARNGAPISETTINGS.RESTRICTED = restricted
        VARNGAPISETTINGS.ALLOWED = allowed
        VARNGAPISETTINGS.RESTRICTION_REASONS = rreasons
    })
}
