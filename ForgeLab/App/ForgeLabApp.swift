import SwiftUI

@main
struct ForgeLabApp: App {
    private let projectRepository: ProjectRepository

    init() {
        let store = JSONProjectStore()
        projectRepository = LocalProjectRepository(store: store)
    }

    var body: some Scene {
        WindowGroup {
            ProjectListView(
                viewModel: ProjectListViewModel(
                    projectRepository: projectRepository
                )
            )
        }
    }
}
