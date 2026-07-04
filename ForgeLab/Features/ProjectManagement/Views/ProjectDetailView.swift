import SwiftUI

struct ProjectDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var listViewModel: ProjectListViewModel

    let projectID: UUID
    let fallbackProject: Project

    @State private var isShowingEditor = false
    @State private var isShowingDeleteConfirmation = false

    var body: some View {
        let project = listViewModel.project(withID: projectID) ?? fallbackProject

        return List {
                Section("Project") {
                    LabeledContent("Name", value: project.name)
                    LabeledContent("Description") {
                        Text(project.summary.isEmpty ? "No description" : project.summary)
                            .foregroundStyle(project.summary.isEmpty ? .secondary : .primary)
                    }
                    LabeledContent("Type", value: project.type.displayName)
                }

                Section("Timeline") {
                    LabeledContent(
                        "Created",
                        value: DateFormatter.forgeLabProjectDate.string(from: project.createdAt)
                    )
                    LabeledContent(
                        "Last Modified",
                        value: DateFormatter.forgeLabProjectDate.string(from: project.updatedAt)
                    )
                }

                Section {
                    NavigationLink {
                        ProjectWorkspaceView(
                            viewModel: ProjectWorkspaceViewModel(
                                project: project,
                                projectRepository: listViewModel.projectRepository
                            )
                        )
                    } label: {
                        Label("Open Workspace", systemImage: "rectangle.grid.2x2")
                    }
                }

                Section {
                    Button(role: .destructive) {
                        isShowingDeleteConfirmation = true
                    } label: {
                        Label("Delete Project", systemImage: "trash")
                    }
                }
            }
            .navigationTitle(project.name)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Edit") {
                        isShowingEditor = true
                    }
                }
            }
            .sheet(isPresented: $isShowingEditor) {
                ProjectFormView(
                    viewModel: ProjectFormViewModel(project: project)
                ) { updatedProject in
                    Task {
                        await listViewModel.save(updatedProject)
                    }
                }
            }
            .confirmationDialog(
                "Delete this project?",
                isPresented: $isShowingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete Project", role: .destructive) {
                    Task {
                        await listViewModel.delete(project)
                        dismiss()
                    }
                }

                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action permanently removes the project from local storage.")
            }
    }
}

#Preview {
    NavigationStack {
        ProjectDetailView(
            listViewModel: ProjectListViewModel(
                projectRepository: PreviewProjectRepository()
            ),
            projectID: UUID(),
            fallbackProject: Project(
                name: "Example App",
                summary: "A sample project.",
                type: .iOSApp
            )
        )
    }
}
