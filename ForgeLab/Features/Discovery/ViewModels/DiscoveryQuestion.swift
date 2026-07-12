import Foundation

struct DiscoveryQuestion: Identifiable, Equatable {
    enum ResponseKind: Equatable {
        case text
        case multiline
        case singleChoice([String])
    }

    let id: String
    let category: String
    let prompt: String
    let responseKind: ResponseKind

    static let all: [DiscoveryQuestion] = [
        DiscoveryQuestion(
            id: "project_goal",
            category: "Project Basics",
            prompt: "What are you building?",
            responseKind: .multiline
        ),
        DiscoveryQuestion(
            id: "problem",
            category: "Project Basics",
            prompt: "What problem does it solve?",
            responseKind: .multiline
        ),
        DiscoveryQuestion(
            id: "users",
            category: "Users",
            prompt: "Who will use this application?",
            responseKind: .multiline
        ),
        DiscoveryQuestion(
            id: "platform",
            category: "Platform",
            prompt: "Which platform are you targeting?",
            responseKind: .singleChoice([
                "iOS",
                "Android",
                "Web",
                "Desktop",
                "Cross-platform",
                "Other"
            ])
        ),
        DiscoveryQuestion(
            id: "features",
            category: "Features",
            prompt: "What are the main features?",
            responseKind: .multiline
        ),
        DiscoveryQuestion(
            id: "authentication",
            category: "Authentication",
            prompt: "Will users need to sign in?",
            responseKind: .singleChoice([
                "Yes",
                "No",
                "Not sure yet"
            ])
        ),
        DiscoveryQuestion(
            id: "database",
            category: "Database",
            prompt: "Will the project require data storage?",
            responseKind: .singleChoice([
                "Yes",
                "No",
                "Not sure yet"
            ])
        ),
        DiscoveryQuestion(
            id: "external_services",
            category: "APIs",
            prompt: "Will it connect to external services?",
            responseKind: .multiline
        ),
        DiscoveryQuestion(
            id: "difficulty",
            category: "Difficulty",
            prompt: "How difficult should the project be?",
            responseKind: .singleChoice([
                "Beginner",
                "Intermediate",
                "Advanced"
            ])
        ),
        DiscoveryQuestion(
            id: "constraints",
            category: "Constraints",
            prompt: "Are there deadlines, technologies, or other constraints to consider?",
            responseKind: .multiline
        )
    ]
}
