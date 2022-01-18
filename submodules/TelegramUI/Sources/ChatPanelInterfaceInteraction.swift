import Foundation
import UIKit
import AsyncDisplayKit
import Postbox
import SwiftSignalKit
import TelegramCore
import Display
import AccountContext
import ContextUI

public enum ChatFinishMediaRecordingAction {
    case dismiss
    case preview
    case send
}

final class ChatPanelInterfaceInteractionStatuses {
    let editingMessage: Signal<Float?, NoError>
    let startingBot: Signal<Bool, NoError>
    let unblockingPeer: Signal<Bool, NoError>
    let searching: Signal<Bool, NoError>
    let loadingMessage: Signal<ChatLoadingMessageSubject?, NoError>
    let inlineSearch: Signal<Bool, NoError>
    
    init(editingMessage: Signal<Float?, NoError>, startingBot: Signal<Bool, NoError>, unblockingPeer: Signal<Bool, NoError>, searching: Signal<Bool, NoError>, loadingMessage: Signal<ChatLoadingMessageSubject?, NoError>, inlineSearch: Signal<Bool, NoError>) {
        self.editingMessage = editingMessage
        self.startingBot = startingBot
        self.unblockingPeer = unblockingPeer
        self.searching = searching
        self.loadingMessage = loadingMessage
        self.inlineSearch = inlineSearch
    }
}

enum ChatPanelSearchNavigationAction {
    case earlier
    case later
    case index(Int)
}

enum ChatPanelRestrictionInfoSubject {
    case mediaRecording
    case stickers
}

enum ChatPanelRestrictionInfoDisplayType {
    case tooltip
    case alert
}

final class ChatPanelInterfaceInteraction {
    let copyForwardMessages:  ([Message]?) -> Void
    let setupReplyMessage: (MessageId?, @escaping (ContainedViewLayoutTransition) -> Void) -> Void
    let setupEditMessage: (MessageId?, @escaping (ContainedViewLayoutTransition) -> Void) -> Void
    let beginMessageSelection: ([MessageId], @escaping (ContainedViewLayoutTransition) -> Void) -> Void
    let deleteSelectedMessages: () -> Void
    let reportSelectedMessages: () -> Void
    let reportMessages: ([Message], ContextControllerProtocol?) -> Void
    let blockMessageAuthor: (Message, ContextControllerProtocol?) -> Void
    let deleteMessages: ([Message], ContextControllerProtocol?, @escaping (ContextMenuActionResult) -> Void) -> Void
    let forwardSelectedMessages: () -> Void
    let forwardCurrentForwardMessages: () -> Void
    let forwardMessages: ([Message]) -> Void
    let updateForwardOptionsState: ((ChatInterfaceForwardOptionsState) -> ChatInterfaceForwardOptionsState) -> Void
    let presentForwardOptions: (ASDisplayNode) -> Void
    let shareSelectedMessages: () -> Void
    let updateTextInputStateAndMode: (@escaping (ChatTextInputState, ChatInputMode) -> (ChatTextInputState, ChatInputMode)) -> Void
    let updateInputModeAndDismissedButtonKeyboardMessageId: ((ChatPresentationInterfaceState) -> (ChatInputMode, MessageId?)) -> Void
    let openStickers: () -> Void
    let editMessage: () -> Void
    let beginMessageSearch: (ChatSearchDomain, String) -> Void
    let dismissMessageSearch: () -> Void
    let updateMessageSearch: (String) -> Void
    let navigateMessageSearch: (ChatPanelSearchNavigationAction) -> Void
    let openSearchResults: () -> Void
    let openCalendarSearch: () -> Void
    let toggleMembersSearch: (Bool) -> Void
    let navigateToMessage: (MessageId, Bool, Bool, ChatLoadingMessageSubject) -> Void
    let navigateToChat: (PeerId) -> Void
    let navigateToProfile: (PeerId) -> Void
    let openPeerInfo: () -> Void
    let togglePeerNotifications: () -> Void
    let sendContextResult: (ChatContextResultCollection, ChatContextResult, ASDisplayNode, CGRect) -> Bool
    let sendBotCommand: (Peer, String) -> Void
    let sendBotStart: (String?) -> Void
    let botSwitchChatWithPayload: (PeerId, String) -> Void
    let beginMediaRecording: (Bool) -> Void
    let finishMediaRecording: (ChatFinishMediaRecordingAction) -> Void
    let stopMediaRecording: () -> Void
    let lockMediaRecording: () -> Void
    let deleteRecordedMedia: () -> Void
    let sendRecordedMedia: (Bool) -> Void
    let displayRestrictedInfo: (ChatPanelRestrictionInfoSubject, ChatPanelRestrictionInfoDisplayType) -> Void
    let displayVideoUnmuteTip: (CGPoint?) -> Void
    let switchMediaRecordingMode: () -> Void
    let setupMessageAutoremoveTimeout: () -> Void
    let sendSticker: (FileMediaReference, Bool, ASDisplayNode, CGRect) -> Bool
    let unblockPeer: () -> Void
    let pinMessage: (MessageId, ContextControllerProtocol?) -> Void
    let unpinMessage: (MessageId, Bool, ContextControllerProtocol?) -> Void
    let unpinAllMessages: () -> Void
    let openPinnedList: (MessageId) -> Void
    let shareAccountContact: () -> Void
    let reportPeer: () -> Void
    let presentPeerContact: () -> Void
    let dismissReportPeer: () -> Void
    let deleteChat: () -> Void
    let beginCall: (Bool) -> Void
    let toggleMessageStickerStarred: (MessageId) -> Void
    let presentController: (ViewController, Any?) -> Void
    let getNavigationController: () -> NavigationController?
    let presentGlobalOverlayController: (ViewController, Any?) -> Void
    let navigateFeed: () -> Void
    let openGrouping: () -> Void
    let toggleSilentPost: () -> Void
    let requestUnvoteInMessage: (MessageId) -> Void
    let requestStopPollInMessage: (MessageId) -> Void
    let updateInputLanguage: (@escaping (String?) -> String?) -> Void
    let unarchiveChat: () -> Void
    let openLinkEditing: () -> Void
    let reportPeerIrrelevantGeoLocation: () -> Void
    let displaySlowmodeTooltip: (ASDisplayNode, CGRect) -> Void
    let displaySendMessageOptions: (ASDisplayNode, ContextGesture) -> Void
    let openScheduledMessages: () -> Void
    let displaySearchResultsTooltip: (ASDisplayNode, CGRect) -> Void
    let openPeersNearby: () -> Void
    let unarchivePeer: () -> Void
    let scrollToTop: () -> Void
    let viewReplies: (MessageId?, ChatReplyThreadMessage) -> Void
    let activatePinnedListPreview: (ASDisplayNode, ContextGesture) -> Void
    let editMessageMedia: (MessageId, Bool) -> Void
    let joinGroupCall: (CachedChannelData.ActiveCall) -> Void
    let presentInviteMembers: () -> Void
    let presentGigagroupHelp: () -> Void
    let updateShowCommands: ((Bool) -> Bool) -> Void
    let updateShowSendAsPeers: ((Bool) -> Bool) -> Void
    let openInviteRequests: () -> Void
    let openSendAsPeer: (ASDisplayNode, ContextGesture?) -> Void
    let presentChatRequestAdminInfo: () -> Void
    let displayCopyProtectionTip: (ASDisplayNode, Bool) -> Void
    let statuses: ChatPanelInterfaceInteractionStatuses?
    
    init(
        copyForwardMessages: @escaping ([Message]?) -> Void,
        setupReplyMessage: @escaping (MessageId?, @escaping (ContainedViewLayoutTransition) -> Void) -> Void,
        setupEditMessage: @escaping (MessageId?, @escaping (ContainedViewLayoutTransition) -> Void) -> Void,
        beginMessageSelection: @escaping ([MessageId], @escaping (ContainedViewLayoutTransition) -> Void) -> Void,
        deleteSelectedMessages: @escaping () -> Void,
        reportSelectedMessages: @escaping () -> Void,
        reportMessages: @escaping ([Message], ContextControllerProtocol?) -> Void,
        blockMessageAuthor: @escaping (Message, ContextControllerProtocol?) -> Void,
        deleteMessages: @escaping ([Message], ContextControllerProtocol?, @escaping (ContextMenuActionResult) -> Void) -> Void,
        forwardSelectedMessages: @escaping () -> Void,
        forwardCurrentForwardMessages: @escaping () -> Void,
        forwardMessages: @escaping ([Message]) -> Void,
        updateForwardOptionsState: @escaping ((ChatInterfaceForwardOptionsState) -> ChatInterfaceForwardOptionsState) -> Void,
        presentForwardOptions: @escaping (ASDisplayNode) -> Void,
        shareSelectedMessages: @escaping () -> Void,
        updateTextInputStateAndMode: @escaping ((ChatTextInputState, ChatInputMode) -> (ChatTextInputState, ChatInputMode)) -> Void,
        updateInputModeAndDismissedButtonKeyboardMessageId: @escaping ((ChatPresentationInterfaceState) -> (ChatInputMode, MessageId?)) -> Void,
        openStickers: @escaping () -> Void,
        editMessage: @escaping () -> Void,
        beginMessageSearch: @escaping (ChatSearchDomain, String) -> Void,
        dismissMessageSearch: @escaping () -> Void,
        updateMessageSearch: @escaping (String) -> Void,
        openSearchResults: @escaping () -> Void,
        navigateMessageSearch: @escaping (ChatPanelSearchNavigationAction) -> Void,
        openCalendarSearch: @escaping () -> Void,
        toggleMembersSearch: @escaping (Bool) -> Void,
        navigateToMessage: @escaping (MessageId, Bool, Bool, ChatLoadingMessageSubject) -> Void,
        navigateToChat: @escaping (PeerId) -> Void,
        navigateToProfile: @escaping (PeerId) -> Void,
        openPeerInfo: @escaping () -> Void,
        togglePeerNotifications: @escaping () -> Void,
        sendContextResult: @escaping (ChatContextResultCollection, ChatContextResult, ASDisplayNode, CGRect) -> Bool,
        sendBotCommand: @escaping (Peer, String) -> Void,
        sendBotStart: @escaping (String?) -> Void,
        botSwitchChatWithPayload: @escaping (PeerId, String) -> Void,
        beginMediaRecording: @escaping (Bool) -> Void,
        finishMediaRecording: @escaping (ChatFinishMediaRecordingAction) -> Void,
        stopMediaRecording: @escaping () -> Void,
        lockMediaRecording: @escaping () -> Void,
        deleteRecordedMedia: @escaping () -> Void,
        sendRecordedMedia: @escaping (Bool) -> Void,
        displayRestrictedInfo: @escaping (ChatPanelRestrictionInfoSubject, ChatPanelRestrictionInfoDisplayType) -> Void,
        displayVideoUnmuteTip: @escaping (CGPoint?) -> Void,
        switchMediaRecordingMode: @escaping () -> Void,
        setupMessageAutoremoveTimeout: @escaping () -> Void,
        sendSticker: @escaping (FileMediaReference, Bool, ASDisplayNode, CGRect) -> Bool,
        unblockPeer: @escaping () -> Void,
        pinMessage: @escaping (MessageId, ContextControllerProtocol?) -> Void,
        unpinMessage: @escaping (MessageId, Bool, ContextControllerProtocol?) -> Void,
        unpinAllMessages: @escaping () -> Void,
        openPinnedList: @escaping (MessageId) -> Void,
        shareAccountContact: @escaping () -> Void,
        reportPeer: @escaping () -> Void,
        presentPeerContact: @escaping () -> Void,
        dismissReportPeer: @escaping () -> Void,
        deleteChat: @escaping () -> Void,
        beginCall: @escaping (Bool) -> Void,
        toggleMessageStickerStarred: @escaping (MessageId) -> Void,
        presentController: @escaping (ViewController, Any?) -> Void,
        getNavigationController: @escaping () -> NavigationController?,
        presentGlobalOverlayController: @escaping (ViewController, Any?) -> Void,
        navigateFeed: @escaping () -> Void,
        openGrouping: @escaping () -> Void,
        toggleSilentPost: @escaping () -> Void,
        requestUnvoteInMessage: @escaping (MessageId) -> Void,
        requestStopPollInMessage: @escaping (MessageId) -> Void,
        updateInputLanguage: @escaping ((String?) -> String?) -> Void,
        unarchiveChat: @escaping () -> Void,
        openLinkEditing: @escaping () -> Void,
        reportPeerIrrelevantGeoLocation: @escaping () -> Void,
        displaySlowmodeTooltip: @escaping (ASDisplayNode, CGRect) -> Void,
        displaySendMessageOptions: @escaping (ASDisplayNode, ContextGesture) -> Void,
        openScheduledMessages: @escaping () -> Void,
        openPeersNearby: @escaping () -> Void,
        displaySearchResultsTooltip: @escaping (ASDisplayNode, CGRect) -> Void,
        unarchivePeer: @escaping () -> Void,
        scrollToTop: @escaping () -> Void,
        viewReplies: @escaping (MessageId?, ChatReplyThreadMessage) -> Void,
        activatePinnedListPreview: @escaping (ASDisplayNode, ContextGesture) -> Void,
        joinGroupCall: @escaping (CachedChannelData.ActiveCall) -> Void,
        presentInviteMembers: @escaping () -> Void,
        presentGigagroupHelp: @escaping () -> Void,
        editMessageMedia: @escaping (MessageId, Bool) -> Void,
        updateShowCommands: @escaping ((Bool) -> Bool) -> Void,
        updateShowSendAsPeers: @escaping ((Bool) -> Bool) -> Void,
        openInviteRequests: @escaping () -> Void,
        openSendAsPeer: @escaping (ASDisplayNode, ContextGesture?) -> Void,
        presentChatRequestAdminInfo: @escaping () -> Void,
        displayCopyProtectionTip: @escaping (ASDisplayNode, Bool) -> Void,
        statuses: ChatPanelInterfaceInteractionStatuses?
    ) {
        self.copyForwardMessages = copyForwardMessages
        self.setupReplyMessage = setupReplyMessage
        self.setupEditMessage = setupEditMessage
        self.beginMessageSelection = beginMessageSelection
        self.deleteSelectedMessages = deleteSelectedMessages
        self.reportSelectedMessages = reportSelectedMessages
        self.reportMessages = reportMessages
        self.blockMessageAuthor = blockMessageAuthor
        self.deleteMessages = deleteMessages
        self.forwardSelectedMessages = forwardSelectedMessages
        self.forwardCurrentForwardMessages = forwardCurrentForwardMessages
        self.forwardMessages = forwardMessages
        self.updateForwardOptionsState = updateForwardOptionsState
        self.presentForwardOptions = presentForwardOptions
        self.shareSelectedMessages = shareSelectedMessages
        self.updateTextInputStateAndMode = updateTextInputStateAndMode
        self.updateInputModeAndDismissedButtonKeyboardMessageId = updateInputModeAndDismissedButtonKeyboardMessageId
        self.openStickers = openStickers
        self.editMessage = editMessage
        self.beginMessageSearch = beginMessageSearch
        self.dismissMessageSearch = dismissMessageSearch
        self.updateMessageSearch = updateMessageSearch
        self.openSearchResults = openSearchResults
        self.navigateMessageSearch = navigateMessageSearch
        self.openCalendarSearch = openCalendarSearch
        self.toggleMembersSearch = toggleMembersSearch
        self.navigateToMessage = navigateToMessage
        self.navigateToChat = navigateToChat
        self.navigateToProfile = navigateToProfile
        self.openPeerInfo = openPeerInfo
        self.togglePeerNotifications = togglePeerNotifications
        self.sendContextResult = sendContextResult
        self.sendBotCommand = sendBotCommand
        self.sendBotStart = sendBotStart
        self.botSwitchChatWithPayload = botSwitchChatWithPayload
        self.beginMediaRecording = beginMediaRecording
        self.finishMediaRecording = finishMediaRecording
        self.stopMediaRecording = stopMediaRecording
        self.lockMediaRecording = lockMediaRecording
        self.deleteRecordedMedia = deleteRecordedMedia
        self.sendRecordedMedia = sendRecordedMedia
        self.displayRestrictedInfo = displayRestrictedInfo
        self.displayVideoUnmuteTip = displayVideoUnmuteTip
        self.switchMediaRecordingMode = switchMediaRecordingMode
        self.setupMessageAutoremoveTimeout = setupMessageAutoremoveTimeout
        self.sendSticker = sendSticker
        self.unblockPeer = unblockPeer
        self.pinMessage = pinMessage
        self.unpinMessage = unpinMessage
        self.unpinAllMessages = unpinAllMessages
        self.openPinnedList = openPinnedList
        self.shareAccountContact = shareAccountContact
        self.reportPeer = reportPeer
        self.presentPeerContact = presentPeerContact
        self.dismissReportPeer = dismissReportPeer
        self.deleteChat = deleteChat
        self.beginCall = beginCall
        self.toggleMessageStickerStarred = toggleMessageStickerStarred
        self.presentController = presentController
        self.getNavigationController = getNavigationController
        self.presentGlobalOverlayController = presentGlobalOverlayController
        self.navigateFeed = navigateFeed
        self.openGrouping = openGrouping
        self.toggleSilentPost = toggleSilentPost
        self.requestUnvoteInMessage = requestUnvoteInMessage
        self.requestStopPollInMessage = requestStopPollInMessage
        self.updateInputLanguage = updateInputLanguage
        self.unarchiveChat = unarchiveChat
        self.openLinkEditing = openLinkEditing
        self.reportPeerIrrelevantGeoLocation = reportPeerIrrelevantGeoLocation
        self.displaySlowmodeTooltip = displaySlowmodeTooltip
        self.displaySendMessageOptions = displaySendMessageOptions
        self.openScheduledMessages = openScheduledMessages
        self.openPeersNearby = openPeersNearby
        self.displaySearchResultsTooltip = displaySearchResultsTooltip
        self.unarchivePeer = unarchivePeer
        self.scrollToTop = scrollToTop
        self.viewReplies = viewReplies
        self.activatePinnedListPreview = activatePinnedListPreview
        self.editMessageMedia = editMessageMedia
        self.joinGroupCall = joinGroupCall
        self.presentInviteMembers = presentInviteMembers
        self.presentGigagroupHelp = presentGigagroupHelp
        self.updateShowCommands = updateShowCommands
        self.updateShowSendAsPeers = updateShowSendAsPeers
        self.openInviteRequests = openInviteRequests
        self.openSendAsPeer = openSendAsPeer
        self.presentChatRequestAdminInfo = presentChatRequestAdminInfo
        self.displayCopyProtectionTip = displayCopyProtectionTip
        self.statuses = statuses
    }
    
    convenience init(
        updateTextInputStateAndMode: @escaping ((ChatTextInputState, ChatInputMode) -> (ChatTextInputState, ChatInputMode)) -> Void,
        updateInputModeAndDismissedButtonKeyboardMessageId: @escaping ((ChatPresentationInterfaceState) -> (ChatInputMode, MessageId?)) -> Void,
        openLinkEditing: @escaping () -> Void
    ) {
        self.init(copyForwardMessages: { _ in },setupReplyMessage: { _, _ in
        }, setupEditMessage: { _, _ in
        }, beginMessageSelection: { _, _ in
        }, deleteSelectedMessages: {
        }, reportSelectedMessages: {
        }, reportMessages: { _, _ in
        }, blockMessageAuthor: { _, _ in
        }, deleteMessages: { _, _, f in
            f(.default)
        }, forwardSelectedMessages: {
        }, forwardCurrentForwardMessages: {
        }, forwardMessages: { _ in
        }, updateForwardOptionsState: { _ in
        }, presentForwardOptions: { _ in
        }, shareSelectedMessages: {
        }, updateTextInputStateAndMode: updateTextInputStateAndMode, updateInputModeAndDismissedButtonKeyboardMessageId: updateInputModeAndDismissedButtonKeyboardMessageId, openStickers: {
        }, editMessage: {
        }, beginMessageSearch: { _, _ in
        }, dismissMessageSearch: {
        }, updateMessageSearch: { _ in
        }, openSearchResults: {
        }, navigateMessageSearch: { _ in
        }, openCalendarSearch: {
        }, toggleMembersSearch: { _ in
        }, navigateToMessage: { _, _, _, _ in
        }, navigateToChat: { _ in
        }, navigateToProfile: { _ in
        }, openPeerInfo: {
        }, togglePeerNotifications: {
        }, sendContextResult: { _, _, _, _ in
            return false
        }, sendBotCommand: { _, _ in
        }, sendBotStart: { _ in
        }, botSwitchChatWithPayload: { _, _ in
        }, beginMediaRecording: { _ in
        }, finishMediaRecording: { _ in
        }, stopMediaRecording: {
        }, lockMediaRecording: {
        }, deleteRecordedMedia: {
        }, sendRecordedMedia: { _ in
        }, displayRestrictedInfo: { _, _ in
        }, displayVideoUnmuteTip: { _ in
        }, switchMediaRecordingMode: {
        }, setupMessageAutoremoveTimeout: {
        }, sendSticker: { _, _, _, _ in
            return false
        }, unblockPeer: {
        }, pinMessage: { _, _ in
        }, unpinMessage: { _, _, _ in
        }, unpinAllMessages: {
        }, openPinnedList: { _ in
        }, shareAccountContact: {
        }, reportPeer: {
        }, presentPeerContact: {
        }, dismissReportPeer: {
        }, deleteChat: {
        }, beginCall: { _ in
        }, toggleMessageStickerStarred: { _ in
        }, presentController: { _, _ in
        }, getNavigationController: {
            return nil
        }, presentGlobalOverlayController: { _, _ in
        }, navigateFeed: {
        }, openGrouping: {
        }, toggleSilentPost: {
        }, requestUnvoteInMessage: { _ in
        }, requestStopPollInMessage: { _ in
        }, updateInputLanguage: { _ in
        }, unarchiveChat: {
        }, openLinkEditing: openLinkEditing, reportPeerIrrelevantGeoLocation: {
        }, displaySlowmodeTooltip: { _, _ in
        }, displaySendMessageOptions: { _, _ in
        }, openScheduledMessages: {
        }, openPeersNearby: {
        }, displaySearchResultsTooltip: { _, _ in
        }, unarchivePeer: {
        }, scrollToTop: {
        }, viewReplies: { _, _ in
        }, activatePinnedListPreview: { _, _ in
        }, joinGroupCall: { _ in
        }, presentInviteMembers: {
        }, presentGigagroupHelp: {
        }, editMessageMedia: { _, _ in
        }, updateShowCommands: { _ in
        }, updateShowSendAsPeers: { _ in
        }, openInviteRequests: {
        }, openSendAsPeer:  { _, _ in
        }, presentChatRequestAdminInfo: {
        }, displayCopyProtectionTip: { _, _ in
        }, statuses: nil)
    }
}
