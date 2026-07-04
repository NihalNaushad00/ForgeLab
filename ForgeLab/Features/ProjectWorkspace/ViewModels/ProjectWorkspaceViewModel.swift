import Foundation
import Combine

@MainActor
final class ProjectWorkspaceViewModel: ObservableObject {
    @Published private(set) var project: Project
    @Published var selectedSection: WorkspaceSection?

    private let projectRepository: ProjectRepository

    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
        project = Project(
            name: "Untitled Project",
            summary: "A documentation-first project workspace."
        )
        selectedSection = WorkspaceSection.allCases.first
    }

    func load() async {
        do {
            if let savedProject = try await projectRepository.fetchProjects().first {
                project = savedProject
            } else {
                try await projectRepository.save(project)
            }
        } catch {
            // The workspace remains usable with its in-memory starter project.
        }
    }
}
