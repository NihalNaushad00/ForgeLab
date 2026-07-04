import SwiftUI

struct ProjectWorkspaceView: View {
    @StateObject private var viewModel: ProjectWorkspaceViewModel

    init(viewModel: ProjectWorkspaceViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationSplitView {
            List(
                WorkspaceSection.allCases,
                selection: $viewModel.selectedSection
            ) { section in
                Label(section.title, systemImage: section.systemImage)
                    .tag(section)
            }
            .navigationTitle("Workspace")
        } detail: {
            if let selectedSection = viewModel.selectedSection {
                WorkspacePlaceholderView(
                    project: viewModel.project,
                    section: selectedSection
                )
            } else {
                ContentUnavailableView(
                    "Select a Section",
                    systemImage: "sidebar.left",
                    description: Text("Choose a workspace area to continue.")
                )
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    let project = Project(
        name: "Sample Project",
        summary: "A preview project for SwiftUI canvas rendering.",
        type: .iOSApp
    )

    ProjectWorkspaceView(
        viewModel: ProjectWorkspaceViewModel(
            project: project,
            projectRepository: PreviewProjectRepository()
        )
    )
}
