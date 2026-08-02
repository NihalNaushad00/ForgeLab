import SwiftUI

struct ProjectWorkspaceView: View {
    @StateObject private var viewModel: ProjectWorkspaceViewModel

    init(viewModel: ProjectWorkspaceViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        workspaceHub
        .task {
            await viewModel.load()
        }
    }

    private var workspaceHub: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Workspace")
                        .font(.largeTitle)
                        .fontWeight(.semibold)

                    Text(viewModel.project.name)
                        .font(.headline)

                    Text("Choose a project area to continue.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            Section("Project Areas") {
                ForEach(WorkspaceSection.allCases) { section in
                    NavigationLink {
                        workspaceDetail(for: section)
                    } label: {
                        Label(section.title, systemImage: section.systemImage)
                    }
                }
            }
        }
        .navigationTitle("Workspace")
    }

    @ViewBuilder
    private func workspaceDetail(for section: WorkspaceSection) -> some View {
        switch section {
        case .overview:
            ProjectOverviewView(
                project: viewModel.project,
                onStartDiscovery: {
                    viewModel.selectedSection = .discovery
                },
                onGeneratePlan: {
                    viewModel.selectedSection = .planner
                }
            )
        case .discovery:
            DiscoverySessionView(
                viewModel: viewModel.makeDiscoverySessionViewModel(),
                isEmbeddedInNavigation: true
            ) { updatedProject in
                viewModel.updateProject(updatedProject)
            }
        case .planner:
            PlannerSummaryView(
                viewModel: viewModel.makePlannerSummaryViewModel(),
                isEmbeddedInNavigation: true
            ) { updatedProject in
                viewModel.updateProject(updatedProject)
            }
        case .codingAgent:
            CodingAgentView(
                viewModel: viewModel.makeCodingAgentViewModel()
            ) { updatedProject in
                viewModel.updateProject(updatedProject)
            }
        case .digitalTwin:
            ProjectDigitalTwinView(
                viewModel: viewModel.makeDigitalTwinViewModel()
            )
        case .specifications,
                .documentation,
                .milestones,
                .tasks,
                .learning,
                .validation,
                .settings:
            WorkspacePlaceholderView(
                section: section,
                project: viewModel.project
            )
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
