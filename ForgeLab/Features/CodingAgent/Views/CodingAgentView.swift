import SwiftUI

struct CodingAgentView: View {
    @StateObject private var viewModel: CodingAgentViewModel

    let onProjectUpdated: (Project) -> Void

    init(
        viewModel: CodingAgentViewModel,
        onProjectUpdated: @escaping (Project) -> Void = { _ in }
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onProjectUpdated = onProjectUpdated
    }

    var body: some View {
        Group {
            if viewModel.productSpecification == nil {
                ContentUnavailableView(
                    "Planner Required",
                    systemImage: "map",
                    description: Text("Generate a Product Specification before preparing Coding Agent work.")
                )
            } else {
                content
            }
        }
        .navigationTitle("Coding Agent")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task {
                        await generateWorkflow()
                    }
                } label: {
                    if viewModel.isSaving {
                        ProgressView()
                    } else {
                        Label(generateButtonTitle, systemImage: "wand.and.stars")
                    }
                }
                .disabled(!viewModel.canGenerateWorkflow)
            }
        }
        .alert(
            "Coding Agent Error",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.clearError() }
            )
        ) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var content: some View {
        List {
            projectSection
            plannerSection
            currentStateSection
            queueSection
            workPackagesSection
        }
    }

    private var projectSection: some View {
        Section("Current Project") {
            LabeledContent("Name", value: viewModel.project.name)
            LabeledContent("Type", value: viewModel.project.type.displayName)
        }
    }

    private var plannerSection: some View {
        Section("Planner Summary") {
            if let specification = viewModel.productSpecification {
                Text(specification.projectSummary)
                LabeledContent("Features", value: "\(specification.mainFeatures.count)")
                LabeledContent("Initial Milestones", value: "\(specification.initialMilestones.count)")
            }
        }
    }

    private var currentStateSection: some View {
        Section("Current State") {
            LabeledContent("Current Milestone", value: viewModel.currentMilestone)
            LabeledContent("Current Work Package", value: viewModel.currentWorkPackage?.title ?? "None")
            LabeledContent("Current Task", value: viewModel.currentTask?.title ?? "None")
            LabeledContent("Current Status", value: viewModel.statusText)

            if viewModel.currentTask != nil {
                Button {
                    Task {
                        await completeCurrentTask()
                    }
                } label: {
                    Label("Complete Current Task", systemImage: "checkmark.circle")
                }
                .disabled(viewModel.isSaving)
            }
        }
    }

    private var queueSection: some View {
        Section("Coding Queue") {
            queueRow(title: "Pending", tasks: viewModel.pendingTasks)
            queueRow(title: "In Progress", tasks: viewModel.inProgressTasks)
            queueRow(title: "Completed", tasks: viewModel.completedTasks)
            queueRow(title: "Future", tasks: viewModel.futureTasks)
        }
    }

    private var workPackagesSection: some View {
        Section("Work Packages") {
            if viewModel.generatedWorkPackages.isEmpty {
                Text("Generate the Coding Agent workflow to create work packages and tasks.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.generatedWorkPackages) { workPackage in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(workPackage.title)
                            .font(.headline)

                        if !workPackage.summary.isEmpty {
                            Text(workPackage.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        ForEach(tasks(for: workPackage)) { task in
                            Label(task.title, systemImage: iconName(for: task.status))
                                .font(.subheadline)
                                .foregroundStyle(task.status == .done ? .secondary : .primary)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
        }
    }

    private var generateButtonTitle: String {
        viewModel.generatedWorkPackages.isEmpty ? "Generate" : "Regenerate"
    }

    private func queueRow(title: String, tasks: [ProjectTask]) -> some View {
        DisclosureGroup("\(title) (\(tasks.count))") {
            if tasks.isEmpty {
                Text("No tasks.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(tasks) { task in
                    Text(task.title)
                }
            }
        }
    }

    private func tasks(for workPackage: WorkPackage) -> [ProjectTask] {
        workPackage.taskIDs.compactMap { taskID in
            viewModel.project.tasks.first { $0.id == taskID }
        }
    }

    private func iconName(for status: TaskStatus) -> String {
        switch status {
        case .todo:
            "circle"
        case .doing:
            "play.circle"
        case .blocked:
            "exclamationmark.circle"
        case .done:
            "checkmark.circle"
        }
    }

    private func generateWorkflow() async {
        if let updatedProject = await viewModel.generateWorkflow() {
            onProjectUpdated(updatedProject)
        }
    }

    private func completeCurrentTask() async {
        if let updatedProject = await viewModel.completeCurrentTask() {
            onProjectUpdated(updatedProject)
        }
    }
}

#Preview {
    CodingAgentView(
        viewModel: CodingAgentViewModel(
            project: Project(
                name: "Sample Project",
                summary: "A preview project for SwiftUI canvas rendering.",
                type: .iOSApp,
                productSpecification: ProductSpecification(
                    projectSummary: "A sample iOS app for previewing ForgeLab planning workflows.",
                    mainFeatures: ["Project List", "Discovery", "Planner"],
                    initialMilestones: ["Build the primary workflow end to end."]
                )
            ),
            projectRepository: PreviewProjectRepository()
        )
    )
}
