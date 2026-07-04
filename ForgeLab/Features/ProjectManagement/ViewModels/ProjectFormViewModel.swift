import Foundation
import Combine

@MainActor
final class ProjectFormViewModel: ObservableObject {
    @Published var name: String
    @Published var summary: String
    @Published var type: ProjectType
    @Published private(set) var validationMessage: String?

    private let existingProject: Project?

    init(project: Project? = nil) {
        existingProject = project
        name = project?.name ?? ""
        summary = project?.summary ?? ""
        type = project?.type ?? .iOSApp
    }

    var title: String {
        existingProject == nil ? "New Project" : "Edit Project"
    }

    var primaryActionTitle: String {
        existingProject == nil ? "Create" : "Save"
    }

    func makeProject() -> Project? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedSummary = summary.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            validationMessage = "Project name is required."
            return nil
        }

        validationMessage = nil

        if var existingProject {
            existingProject.name = trimmedName
            existingProject.summary = trimmedSummary
            existingProject.type = type
            existingProject.updatedAt = Date()
            return existingProject
        }

        return Project(
            name: trimmedName,
            summary: trimmedSummary,
            type: type
        )
    }
}
