import Foundation

actor LocalProjectRepository: ProjectRepository {
    private let store: ProjectStore

    init(store: ProjectStore) {
        self.store = store
    }

    func fetchProjects() async throws -> [Project] {
        try await store.loadProjects()
    }

    func project(withID id: UUID) async throws -> Project? {
        try await store.loadProjects().first { $0.id == id }
    }

    func save(_ project: Project) async throws {
        var projectToSave = project
        projectToSave.updatedAt = Date()

        var projects = try await store.loadProjects()

        if let index = projects.firstIndex(where: { $0.id == projectToSave.id }) {
            projects[index] = projectToSave
        } else {
            projects.append(projectToSave)
        }

        try await store.saveProjects(projects)
    }

    func deleteProject(withID id: UUID) async throws {
        let projects = try await store.loadProjects()
            .filter { $0.id != id }

        try await store.saveProjects(projects)
    }
}
