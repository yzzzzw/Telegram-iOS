import Foundation
import WGRequests

struct GlobalNGSettingsObj: Decodable {
    let gmod: Bool
    let youtube_pip: Bool
    let qr_login_camera: Bool
    let gmod2: Bool
    let gmod3: Bool
    let translate_rules: [TranslateRule]
}

public struct TranslateRule: Codable {
    public let name: String
    public let pattern: String
    public let data_check: String
    public let match_group: Int
}
///全局设置GWGSettings()，gmod、youtube_pip、qr_login_camera、gmod2、gmod3、translate_rules（谷歌翻译网页解析规则）
public var VarGWGSettings = GWGSettings()
// MARK: Wellgram repository
public let WGRepository = "yzzzzw"

public class GWGSettings {
    let UD = UserDefaults(suiteName: "GlobalNGSettings")

    public init() {
        UD?.register(defaults:
            [
                "gmod": false,
                "youtube_pip": true,
                "qr_login_camera": false,
                "gmod2": false,
                "gmod3": false,
            ])
    }

    public var gmod: Bool {
        get {
            return UD?.bool(forKey: "gmod") ?? false
        }
        set {
            UD?.set(newValue, forKey: "gmod")
        }
    }

    public var youtube_pip: Bool {
        get {
            return UD?.bool(forKey: "youtube_pip") ?? true
        }
        set {
            UD?.set(newValue, forKey: "youtube_pip")
        }
    }

    public var qr_login_camera: Bool {
        get {
            return UD?.bool(forKey: "qr_login_camera") ?? false
        }
        set {
            UD?.set(newValue, forKey: "qr_login_camera")
        }
    }

    public var gmod2: Bool {
        get {
            return UD?.bool(forKey: "gmod2") ?? false
        }
        set {
            UD?.set(newValue, forKey: "gmod2")
        }
    }

    public var gmod3: Bool {
        get {
            return UD?.bool(forKey: "gmod3") ?? false
        }
        set {
            UD?.set(newValue, forKey: "gmod3")
        }
    }
    ///翻译网页解析规则
    public var translate_rules: [TranslateRule] {
        get {
            if let savedTranslateRules = UD?.object(forKey: "TranslateRules") as? Data {
                let decoder = PropertyListDecoder()
                do {
                    let loadedTranslateRules = try decoder.decode(Array<TranslateRule>.self, from: savedTranslateRules)
                    return loadedTranslateRules
                } catch let error as NSError {
                    NSLog("Cant load TranslateRules from UD \(error.localizedDescription)")
                }
            }
            
            return [
                TranslateRule(
                    name: "new_mobile",
                    pattern: "<div class=\"result-container\">([\\s\\S]+)</div><div class=",
                    data_check: "<div class=\"result-container\">",
                    match_group: 1
                ),
                TranslateRule(
                    name: "old_mobile",
                    pattern: "<div dir=\"(ltr|rtl)\" class=\"t0\">([\\s\\S]+)</div><form action=",
                    data_check: "class=\"t0\">",
                    match_group: 2
                )
            ]
        }
        set {
            let encoder = PropertyListEncoder()
            do {
                let encoded = try encoder.encode(newValue)
                UD?.set(encoded, forKey: "TranslateRules")
            } catch let error as NSError {
                NSLog("Cant set TranslateRules to UD \(error)")
            }
        }
    }
}
///获取全局设置路径,build为git分支名称
func getGlobalSettingsUrl(_ build: String) -> String {
    return "https://raw.githubusercontent.com/" + WGRepository + "/settings/\(build)/global.json"
}
///解析和设置全局数据
func parseAndSetGlobalData(data: Data) -> Bool {
    do {
        let _ = try JSONDecoder().decode(GlobalNGSettingsObj.self, from: data)
    } catch let error as NSError {
        NSLog("Error: Couldn't decode data into globalsettings model \(error)")
        return false
    }
    
    let parsedSettings = try! JSONDecoder().decode(GlobalNGSettingsObj.self, from: data)
    let currentSettings = VarGWGSettings
    currentSettings.gmod = parsedSettings.gmod
    currentSettings.youtube_pip = parsedSettings.youtube_pip
    currentSettings.qr_login_camera = parsedSettings.qr_login_camera
    currentSettings.gmod2 = parsedSettings.gmod2
    currentSettings.gmod3 = parsedSettings.gmod3
    currentSettings.translate_rules = parsedSettings.translate_rules
    return true
}
///更新全局设置
public func updateGlobalNGSettings(_ build: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"]) as! String) {
    
    let url = getGlobalSettingsUrl(build)
    
    let _ = RequestsGet(url: URL(string: url)!).start(next: { data, _ in
        let settingsResult = parseAndSetGlobalData(data: data)
        
        if !settingsResult && build != "master" {
            updateGlobalNGSettings("master")
        }

    }, error: { _ in
        NSLog("HTTP error \(build)")
    })
}
