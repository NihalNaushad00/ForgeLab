import Foundation

struct PreviewProjectRepository: ProjectRepository {
    func fetchProjects() async throws -> [Project] {
        [
            Project(
                name: "Sample Project",
                summary: "A preview project for SwiftUI canvas rendering."
            )
        ]
    }

    func save(_ project: Project) async throws {}
}
