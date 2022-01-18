import Foundation
import Postbox
import TelegramCore
import WGData

public func getTgId(_ peer: Peer?) -> Int64 {
    if let peer = peer {
        var peerId: Int64
        if let peer = peer as? TelegramUser  {
            peerId = peer.id.id._internalGetInt64Value()
        } else { // Channels, Chats, Groups
            peerId = Int64("-100" + String(peer.id.id._internalGetInt64Value())) ?? 1
        }
        return peerId
    }
    return 0
}

public func isNGForceBlocked(_ peer: Peer?) -> Bool {
    let peerId = getTgId(peer)
    if VARNGAPISETTINGS.RESTRICTED.contains(peerId) {
        return true
    }
    return false
}

public func isNGForceAllowed(_ peer: Peer?) -> Bool {
    let peerId = getTgId(peer)
    if VARNGAPISETTINGS.ALLOWED.contains(peerId) {
        return true
    }
    return false
}

public func isNGAllowedReason(_ peer: Peer?, _ contentSettings: ContentSettings) -> Bool {
    var isAllowedReason = true
//    if let peer = peer {
//        if let restrictionReason = peer.restrictionText(platform: "ios", contentSettings: contentSettings, extractReason: true) {
//            if !VARNGAPISETTINGS.RESTRICTION_REASONS.contains(restrictionReason)  {
//                isAllowedReason = false
//            }
//        }
//    }
    return isAllowedReason
}

public func isAllowedChat(peer: Peer?, contentSettings: ContentSettings
) -> Bool {
    var isAllowed: Bool = false
    if VARNGAPISETTINGS.SYNC_CHATS {
        if isNGAllowedReason(peer, contentSettings) {
            isAllowed = true
        }
    }
    
    if isNGForceAllowed(peer){
        isAllowed = true
    }
    
    if isNGForceBlocked(peer) {
        isAllowed = false
    }
    return isAllowed
}


public func isAllowedMessage(restrictionReason: String?, contentSettings: ContentSettings) -> Bool {
    var isAllowed: Bool = true
    if let restrictionReason = restrictionReason {
        if VARNGAPISETTINGS.SYNC_CHATS {
            if !VARNGAPISETTINGS.RESTRICTION_REASONS.contains(restrictionReason)  {
                isAllowed = false
            }
        }
    }
    
    return isAllowed
}



