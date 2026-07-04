import Foundation

struct PreviewProjectRepository: ProjectRepository {
    func fetchProjects() async throws -> [Project] {
        [
            Project(
                name: "Sample Project",
                summary: "A preview project for SwiftUI canvas rendering.",
                type: .iOSApp
            )
        ]
    }

    func project(withID id: UUID) async throws -> Project? {
        try await fetchProjects().first { $0.id == id }
    }

    func save(_ project: Project) async throws {}

    func deleteProject(withID id: UUID) async throws {}
}
