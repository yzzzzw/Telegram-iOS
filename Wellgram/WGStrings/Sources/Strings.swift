import Foundation
import AppBundle
import WGData

private func gd(locale: String) -> [String : String] {
    return NSDictionary(contentsOf: URL(fileURLWithPath: getAppBundle().path(forResource: "WellLocalizable", ofType: "strings", inDirectory: nil, forLocalization: locale)!)) as! [String : String]
}

let niceLocales: [String : [String : String]] = [
    "en": gd(locale: "en"),
    "ru": gd(locale: "ru"),
    "ar": gd(locale: "ar"),
    "de": gd(locale: "de"),
    "it": gd(locale: "it"),
    "es": gd(locale: "es"),
    "uk": gd(locale: "uk"),
    "fa": gd(locale: "fa"),
    "pl": gd(locale: "pl"),
    "sk": gd(locale: "sk"),
    "tr": gd(locale: "tr"),
    "ro": gd(locale: "ro"),
    "ko": gd(locale: "ko"),
    "ku": gd(locale: "ku"),
    "be": [:],
    // Chinese
    // Simplified
    "zh-hans": gd(locale: "zh-hans"),
    // Traditional
    "zh-hant": gd(locale: "zh-hant"),
]

public func getLangFallback(_ lang: String) -> String {
    switch (lang) {
    case "zh-hant":
        return "zh-hans"
    case "uk", "be":
        return "ru"
    case "ckb":
        return "ku"
    case "sdh": // Need investigate
        return "ku"
    default:
        return "en"
    }
}

func getFallbackKey(_ key: String) -> String {
    switch (key) {
    case "NicegramSettings.Notifications.hideAccountInNotification":
        return "NiceFeatures.Notifications.HideNotifyAccount"
    case "NicegramSettings.Notifications.hideAccountInNotificationNotice":
        return "NiceFeatures.Notifications.HideNotifyAccountNotice"
    case "NicegramSettings.Tabs":
        return "NiceFeatures.Tabs.Header"
    case "NicegramSettings.Tabs.showContactsTab":
        return "NiceFeatures.Tabs.ShowContacts"
    case "NicegramSettings.Tabs.showTabNames":
        return "NiceFeatures.Tabs.ShowNames"
    case "NicegramSettings.Folders":
        return "NiceFeatures.Folders.Header"
    case "NicegramSettings.Folders.foldersAtBottom":
        return "NiceFeatures.Folders.TgFolders"
    case "NicegramSettings.Folders.foldersAtBottomNotice":
        return "NiceFeatures.Folders.TgFolders.Notice"
    case "NicegramSettings.RoundVideos":
        return "NiceFeatures.RoundVideos.Header"
    case "NicegramSettings.RoundVideos.startWithRearCam":
        return "NiceFeatures.RoundVideos.UseRearCamera"
    case "NicegramSettings.Other.hidePhoneInSettings":
        return "NiceFeatures.HideNumber"
        
    default:
        return key
    }
}
///获取本地化文本
public func l(_ key: String, _ locale: String = "en") -> String {
    var lang = locale
    let key = getFallbackKey(key)
    let rawSuffix = "-raw"
    if lang.hasSuffix(rawSuffix) {
        lang = String(lang.dropLast(rawSuffix.count))
    }
    
    if !niceLocales.keys.contains(lang) {
        lang = "en"
    }
    
    var result = "[MISSING STRING. PLEASE UPDATE APP]"
    
    if let res = niceWebLocales[lang]?[key], !res.isEmpty {
        result = res
    } else if let res = niceLocales[lang]?[key], !res.isEmpty {
        result = res
    } else if let res = niceLocales[getLangFallback(lang)]?[key], !res.isEmpty {
        result = res
    } else if let res = niceLocales["en"]?[key], !res.isEmpty {
        result = res
    } else if !key.isEmpty {
        result = key
    }
    
    return result
}

///获取语言本地化文件路径，本地化文件上传github后的文件地址
public func getStringsUrl(_ lang: String) -> String {
    return "https://raw.githubusercontent.com/" + WGRepository +  "/Telegram-iOS/master/Telegram/Telegram-iOS/" + lang + ".lproj/WellLocalizable.strings"
}


var niceWebLocales: [String: [String: String]] = [:]

func getWebDict(_ lang: String) -> [String : String]? {
    return NSDictionary(contentsOf: URL(string: getStringsUrl(lang))!) as? [String : String]
}
//下载本地化文件内容
public func downloadLocale(_ locale: String) -> Void {
    do {
        var lang = locale
        let rawSuffix = "-raw"
        if lang.hasSuffix(rawSuffix) {
            lang = String(lang.dropLast(rawSuffix.count))
        }
        if let localeDict = try getWebDict(lang) {
            niceWebLocales[lang] = localeDict
        } else {
            print("localeDict is nil")
        }
    } catch {
        print("download fail")
        return
    }
}
