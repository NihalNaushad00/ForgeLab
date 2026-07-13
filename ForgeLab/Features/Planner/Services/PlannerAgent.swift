import Foundation

struct PlannerAgent {
    func generateSpecification(for project: Project) -> ProductSpecification? {
        guard let discoverySession = project.discoverySession else {
            return nil
        }

        let answers = DiscoveryAnswerIndex(answers: discoverySession.answers)
        let features = splitList(answers.response(for: "features"))

        return ProductSpecification(
            projectSummary: projectSummary(for: project, answers: answers),
            recommendedTechStack: recommendedTechStack(for: project, answers: answers),
            architectureStyle: architectureStyle(for: answers),
            mainFeatures: features.isEmpty ? fallbackFeatures(for: answers) : features,
            suggestedFolderStructure: suggestedFolderStructure(for: answers),
            databaseRequirement: databaseRequirement(for: answers),
            authenticationRequirement: authenticationRequirement(for: answers),
            apiRequirement: apiRequirement(for: answers),
            initialMilestones: initialMilestones(for: answers, features: features),
            generatedAt: Date(),
            sourceDiscoverySessionID: discoverySession.id
        )
    }

    private func projectSummary(for project: Project, answers: DiscoveryAnswerIndex) -> String {
        let goal = answers.response(for: "project_goal", fallback: project.name)
        let problem = answers.response(for: "problem", fallback: "the user problem captured during discovery")
        let users = answers.response(for: "users", fallback: "the target users")
        let platform = answers.response(for: "platform", fallback: project.type.displayName)

        return "\(goal) for \(users). It targets \(platform) and focuses on solving \(problem)."
    }

    private func recommendedTechStack(
        for project: Project,
        answers: DiscoveryAnswerIndex
    ) -> [String] {
        let platform = answers.response(for: "platform", fallback: project.type.displayName).lowercased()
        var stack: [String]

        if platform.contains("ios") {
            stack = ["Swift", "SwiftUI", "MVVM", "Local JSON persistence for the first version"]
        } else if platform.contains("android") {
            stack = ["Kotlin", "Jetpack Compose", "MVVM", "Local persistence for the first version"]
        } else if platform.contains("web") {
            stack = ["TypeScript", "React", "Component-based UI", "Local API-ready data layer"]
        } else if platform.contains("cross") {
            stack = ["TypeScript", "React Native", "Feature-based modules", "Repository data layer"]
        } else {
            stack = ["Feature-based application structure", "MVVM-style presentation layer", "Repository data layer"]
        }

        if answers.response(for: "database").localizedCaseInsensitiveContains("yes") {
            stack.append("Structured persistence layer")
        }

        if requiresExternalAPI(answers: answers) {
            stack.append("API service layer")
        }

        return stack
    }

    private func architectureStyle(for answers: DiscoveryAnswerIndex) -> String {
        let difficulty = answers.response(for: "difficulty", fallback: "Beginner")

        if difficulty.localizedCaseInsensitiveContains("advanced") {
            return "Modular MVVM with feature modules, repository-backed services, and clear domain models."
        }

        if difficulty.localizedCaseInsensitiveContains("intermediate") {
            return "Feature-based MVVM with a small service layer and persistent project state."
        }

        return "Simple MVVM with feature folders, view models, models, and repository-backed persistence."
    }

    private func suggestedFolderStructure(for answers: DiscoveryAnswerIndex) -> [String] {
        var folders = [
            "App/",
            "Core/Persistence/",
            "Features/",
            "Models/",
            "Services/",
            "Resources/",
            "Utilities/"
        ]

        if requiresExternalAPI(answers: answers) {
            folders.append("Services/API/")
        }

        return folders
    }

    private func databaseRequirement(for answers: DiscoveryAnswerIndex) -> String {
        switch normalizedDecision(answers.response(for: "database")) {
        case .yes:
            return "Required. Start with a repository-backed persistence layer and keep storage replaceable for future cloud or database integration."
        case .no:
            return "Not required for the first version. Keep domain models Codable so persistence can be added later if scope changes."
        case .unsure:
            return "Unclear. Begin with local persistence for user-created project state and defer a database decision until core workflows are validated."
        }
    }

    private func authenticationRequirement(for answers: DiscoveryAnswerIndex) -> String {
        switch normalizedDecision(answers.response(for: "authentication")) {
        case .yes:
            return "Required. Plan for account creation, sign-in, signed-out states, and protected user data boundaries."
        case .no:
            return "Not required for the first version. Keep the app usable without account setup."
        case .unsure:
            return "Unclear. Defer authentication until the minimum useful workflow proves it needs user identity."
        }
    }

    private func apiRequirement(for answers: DiscoveryAnswerIndex) -> String {
        let externalServices = answers.response(for: "external_services")

        if requiresExternalAPI(answers: answers) {
            return "Required or likely. Isolate external integrations behind service protocols and keep the UI independent of network details. Discovery notes: \(externalServices)"
        }

        return "No external API requirement is explicit in discovery. Keep the app structured so an API layer can be introduced later."
    }

    private func initialMilestones(for answers: DiscoveryAnswerIndex, features: [String]) -> [String] {
        var milestones = [
            "Define core models and local data flow.",
            "Build the primary user workflow end to end.",
            "Add persistence and state restoration.",
            "Polish empty, loading, and error states."
        ]

        if !features.isEmpty {
            milestones.insert("Implement core feature set: \(features.prefix(3).joined(separator: ", ")).", at: 1)
        }

        if normalizedDecision(answers.response(for: "authentication")) == .yes {
            milestones.append("Add authentication and protected-session handling.")
        }

        if requiresExternalAPI(answers: answers) {
            milestones.append("Integrate external services behind a testable API layer.")
        }

        return milestones
    }

    private func fallbackFeatures(for answers: DiscoveryAnswerIndex) -> [String] {
        let goal = answers.response(for: "project_goal", fallback: "Core project workflow")
        return [goal]
    }

    private func splitList(_ text: String) -> [String] {
        text
            .components(separatedBy: CharacterSet(charactersIn: "\n,;"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines.union(CharacterSet(charactersIn: "-*"))) }
            .filter { !$0.isEmpty }
    }

    private func requiresExternalAPI(answers: DiscoveryAnswerIndex) -> Bool {
        let response = answers.response(for: "external_services").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !response.isEmpty else {
            return false
        }

        return !["no", "none", "not sure", "not sure yet", "n/a"].contains(response.lowercased())
    }

    private func normalizedDecision(_ value: String) -> DiscoveryDecision {
        if value.localizedCaseInsensitiveContains("yes") {
            return .yes
        }

        if value.localizedCaseInsensitiveContains("no") {
            return .no
        }

        return .unsure
    }
}

private enum DiscoveryDecision {
    case yes
    case no
    case unsure
}

private struct DiscoveryAnswerIndex {
    private let answersByID: [String: DiscoveryAnswer]

    init(answers: [DiscoveryAnswer]) {
        answersByID = Dictionary(uniqueKeysWithValues: answers.map { ($0.questionID, $0) })
    }

    func response(for questionID: String, fallback: String = "") -> String {
        let response = answersByID[questionID]?.response.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return response.isEmpty ? fallback : response
    }
}
