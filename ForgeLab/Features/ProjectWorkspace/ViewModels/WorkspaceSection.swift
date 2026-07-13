import Foundation

enum WorkspaceSection: String, CaseIterable, Hashable, Identifiable {
    case overview
    case discovery
    case planner
    case specifications
    case documentation
    case milestones
    case tasks
    case learning
    case validation
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .overview:
            "Overview"
        case .discovery:
            "Discovery"
        case .planner:
            "Project Planner"
        case .specifications:
            "Specifications"
        case .documentation:
            "Documentation"
        case .milestones:
            "Milestones"
        case .tasks:
            "Tasks"
        case .learning:
            "Learning"
        case .validation:
            "Validation"
        case .settings:
            "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .overview:
            "rectangle.grid.2x2"
        case .discovery:
            "checklist"
        case .planner:
            "map"
        case .specifications:
            "doc.text"
        case .documentation:
            "books.vertical"
        case .milestones:
            "flag"
        case .tasks:
            "list.bullet.clipboard"
        case .learning:
            "graduationcap"
        case .validation:
            "checkmark.seal"
        case .settings:
            "gearshape"
        }
    }
}
