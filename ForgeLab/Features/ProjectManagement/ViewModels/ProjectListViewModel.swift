import Foundation
import Combine

@MainActor
final class ProjectListViewModel: ObservableObject {
    @Published private(set) var projects: [Project] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading = false

    let projectRepository: ProjectRepository

    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }

    func loadProjects() async {
        isLoading = true
        defer { isLoading = false }

        do {
            projects = try await projectRepository.fetchProjects()
                .sorted { $0.updatedAt > $1.updatedAt }
            errorMessage = nil
        } catch {
            projects = []
            errorMessage = "Projects could not be loaded."
        }
    }

    func save(_ project: Project) async {
        do {
            try await projectRepository.save(project)
            await loadProjects()
        } catch {
            errorMessage = "Project could not be saved."
        }
    }

    func delete(_ project: Project) async {
        do {
            try await projectRepository.deleteProject(withID: project.id)
            await loadProjects()
        } catch {
            errorMessage = "Project could not be deleted."
        }
    }

    func project(withID id: UUID) -> Project? {
        projects.first { $0.id == id }
    }

    func clearError() {
        errorMessage = nil
    }
}
