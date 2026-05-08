import UIKit
import VoximplantKitChatUI

extension KitChatColorScheme {
    var viColorScheme: VIKitChatCustomizableColors {
        var colors = VIKitChatCustomizableColors()
        colors.brand = brand?.viUIColor ?? colors.brand
        colors.brandContainer = brandContainer?.viUIColor ?? colors.brandContainer
        colors.negative = negative?.viUIColor ?? colors.negative
        colors.negativeContainer = negativeContainer?.viUIColor ?? colors.negativeContainer
        colors.onBrand = onBrand?.viUIColor ?? colors.onBrand
        colors.onBrandContainer = onBrandContainer?.viUIColor ?? colors.onBrandContainer
        colors.positive = positive?.viUIColor ?? colors.positive
        colors.positiveContainer = positiveContainer?.viUIColor ?? colors.positiveContainer
        if let avatarPlaceholderColor = avatarPlaceholder?.viUIColor,
           avatarPlaceholderColor.cgColor.alpha > 0 {
            colors.avatarPlaceholder = avatarPlaceholderColor
        }
        return colors
    }
}

extension KitChatCustomizableStringsIos {
    var viCustomizableStrings: VIKitChatCustomizableStrings {
        var strings = VIKitChatCustomizableStrings()

        strings.chatTitle = chatTitle
        strings.messagePlaceholder = messagePlaceholder

        strings.attachmentPicker.camera = attachmentPicker?.camera
        strings.attachmentPicker.file = attachmentPicker?.file
        strings.attachmentPicker.gallery = attachmentPicker?.gallery

        strings.connectionState.connecting = connectionState?.connecting
        strings.connectionState.online = connectionState?.online
        strings.connectionState.offline = connectionState?.offline

        strings.contextMenu.copyTextAction = contextMenu?.copyTextAction
        strings.contextMenu.resendMessageAction = contextMenu?.resendMessageAction
        strings.contextMenu.saveImageAction = contextMenu?.saveImageAction

        strings.errors.fileSizeError = error?.fileSizeError
        strings.errors.fileTypeError = error?.fileTypeError
        strings.errors.invalidFileError = error?.invalidFileError
        strings.errors.multipleInvalidFilesError = error?.multipleInvalidFilesError

        strings.notice.accessFileError = notice?.accessFileError
        strings.notice.copyTextSuccess = notice?.copyTextSuccess
        strings.notice.fileLimitError = notice?.fileLimitError
        strings.notice.openImageError = notice?.openImageError
        strings.notice.saveImageError = notice?.saveImageError
        strings.notice.saveImageSuccess = notice?.saveImageSuccess
        strings.notice.sendInvalidFilesError = notice?.sendInvalidFilesError

        strings.permissionAlert.closeAction = permission?.closeAction
        strings.permissionAlert.settingsAction = permission?.settingsAction
        strings.permissionAlert.title = permission?.title

        strings.senders.agentDisplayName = sender?.agentDisplayName
        strings.senders.botDisplayName = sender?.botDisplayName

        return strings
    }
}

extension KitChatCustomizableIconsIos {
    var viCustomizableIcons: VIKitChatCustomizableIcons {
        var icons = VIKitChatCustomizableIcons()

        icons.error = error?.viUIImage
        icons.success = success?.viUIImage

        icons.actions.add = actions?.add?.viUIImage
        icons.actions.back = actions?.back?.viUIImage
        icons.actions.chooseFile = actions?.chooseFile?.viUIImage
        icons.actions.copy = actions?.copy?.viUIImage
        icons.actions.resend = actions?.resend?.viUIImage
        icons.actions.save = actions?.save?.viUIImage
        icons.actions.selectFromGallery = actions?.selectFromGallery?.viUIImage
        icons.actions.send = actions?.send?.viUIImage
        icons.actions.share = actions?.share?.viUIImage
        icons.actions.takePhoto = actions?.takePhoto?.viUIImage

        icons.attachments.document = attachments?.document?.viUIImage
        icons.attachments.download = attachments?.download?.viUIImage
        icons.attachments.error = attachments?.error?.viUIImage

        icons.senders.agent = senders?.agent?.viUIImage
        icons.senders.bot = senders?.bot?.viUIImage

        return icons
    }
}

private extension Int64 {
    var viUIColor: UIColor? {
        let value = UInt32(truncatingIfNeeded: self)
        let alpha = CGFloat((value >> 24) & 0xFF) / 255.0
        let red = CGFloat((value >> 16) & 0xFF) / 255.0
        let green = CGFloat((value >> 8) & 0xFF) / 255.0
        let blue = CGFloat(value & 0xFF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

private extension String {
    var viUIImage: UIImage? {
        UIImage(named: self, in: .main, with: nil)
    }
}
