import Foundation

actor LocalProjectRepository: ProjectRepository {
    private let store: ProjectStore

    init(store: ProjectStore) {
        self.store = store
    }

    func fetchProjects() async throws -> [Project] {
        try await store.loadProjects()
    }

    func save(_ project: Project) async throws {
        var projects = try await store.loadProjects()

        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects[index] = project
        } else {
            projects.append(project)
        }

        try await store.saveProjects(projects)
    }
}
