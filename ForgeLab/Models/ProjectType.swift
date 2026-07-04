import Foundation

enum ProjectType: String, CaseIterable, Codable, Identifiable, Sendable {
    case iOSApp
    case androidApp
    case webApp
    case desktopApp
    case api
    case aiApplication
    case game
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .iOSApp:
            "iOS App"
        case .androidApp:
            "Android App"
        case .webApp:
            "Web App"
        case .desktopApp:
            "Desktop App"
        case .api:
            "API"
        case .aiApplication:
            "AI Application"
        case .game:
            "Game"
        case .other:
            "Other"
        }
    }
}
