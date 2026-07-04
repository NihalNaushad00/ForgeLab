import SwiftUI

struct ProjectListView: View {
    @StateObject private var viewModel: ProjectListViewModel
    @State private var isShowingNewProject = false

    init(viewModel: ProjectListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.projects.isEmpty {
                    ContentUnavailableView {
                        Label("No Projects", systemImage: "folder")
                    } description: {
                        Text("Create a ForgeLab project to begin planning your work.")
                    } actions: {
                        Button("New Project") {
                            isShowingNewProject = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List(viewModel.projects) { project in
                        NavigationLink(value: project.id) {
                            ProjectRowView(project: project)
                        }
                    }
                }
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingNewProject = true
                    } label: {
                        Label("New Project", systemImage: "plus")
                    }
                }
            }
            .navigationDestination(for: UUID.self) { projectID in
                if let project = viewModel.project(withID: projectID) {
                    ProjectDetailView(
                        listViewModel: viewModel,
                        projectID: project.id,
                        fallbackProject: project
                    )
                } else {
                    ContentUnavailableView(
                        "Project Not Found",
                        systemImage: "exclamationmark.triangle",
                        description: Text("The selected project is no longer available.")
                    )
                }
            }
            .sheet(isPresented: $isShowingNewProject) {
                ProjectFormView(viewModel: ProjectFormViewModel()) { project in
                    Task {
                        await viewModel.save(project)
                    }
                }
            }
            .task {
                await viewModel.loadProjects()
            }
            .refreshable {
                await viewModel.loadProjects()
            }
            .alert(
                "Project Error",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { isPresented in
                        if !isPresented {
                            viewModel.clearError()
                        }
                    }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

#Preview {
    ProjectListView(
        viewModel: ProjectListViewModel(
            projectRepository: PreviewProjectRepository()
        )
    )
}
