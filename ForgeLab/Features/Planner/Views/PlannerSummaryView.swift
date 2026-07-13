import SwiftUI

struct PlannerSummaryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PlannerSummaryViewModel

    let onProjectUpdated: (Project) -> Void
    let isEmbeddedInNavigation: Bool

    init(
        viewModel: PlannerSummaryViewModel,
        isEmbeddedInNavigation: Bool = false,
        onProjectUpdated: @escaping (Project) -> Void = { _ in }
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.isEmbeddedInNavigation = isEmbeddedInNavigation
        self.onProjectUpdated = onProjectUpdated
    }

    var body: some View {
        if isEmbeddedInNavigation {
            content
        } else {
            NavigationStack {
                content
            }
        }
    }

    private var content: some View {
        Group {
            if let specification = viewModel.productSpecification {
                specificationContent(specification)
            } else if viewModel.canGeneratePlan {
                generatingContent
            } else {
                ContentUnavailableView(
                    "Discovery Required",
                    systemImage: "questionmark.folder",
                    description: Text("Complete Discovery before generating a project plan.")
                )
            }
        }
        .navigationTitle("Project Planner")
        .toolbar {
            if !isEmbeddedInNavigation {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Workspace") {
                        dismiss()
                    }
                }
            }

            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task {
                        await generatePlan()
                    }
                } label: {
                    if viewModel.isGenerating {
                        ProgressView()
                    } else {
                        Label("Regenerate", systemImage: "arrow.clockwise")
                    }
                }
                .disabled(!viewModel.canGeneratePlan || viewModel.isGenerating)
            }
        }
        .task {
            if viewModel.productSpecification == nil, viewModel.canGeneratePlan {
                await generatePlan()
            }
        }
        .alert(
            "Planner Error",
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

    private var generatingContent: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Generating Project Plan")
                .font(.headline)
            Text("The Planner Agent is organizing the completed Discovery answers into a Product Specification.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private func specificationContent(_ specification: ProductSpecification) -> some View {
        List {
            Section("Project Summary") {
                Text(specification.projectSummary)
            }

            listSection("Recommended Tech Stack", items: specification.recommendedTechStack)

            Section("Architecture Style") {
                Text(specification.architectureStyle)
            }

            listSection("Main Features", items: specification.mainFeatures)
            listSection("Suggested Folder Structure", items: specification.suggestedFolderStructure)

            Section("Database Requirement") {
                Text(specification.databaseRequirement)
            }

            Section("Authentication Requirement") {
                Text(specification.authenticationRequirement)
            }

            Section("API Requirement") {
                Text(specification.apiRequirement)
            }

            listSection("Initial Milestones", items: specification.initialMilestones)

            Section("Planner Summary") {
                LabeledContent(
                    "Generated",
                    value: DateFormatter.forgeLabProjectDate.string(from: specification.generatedAt)
                )
                LabeledContent("Sections", value: "9")
            }
        }
    }

    private func listSection(_ title: String, items: [String]) -> some View {
        Section(title) {
            if items.isEmpty {
                Text("No items identified.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
            }
        }
    }

    private func generatePlan() async {
        if let updatedProject = await viewModel.generatePlan() {
            onProjectUpdated(updatedProject)
        }
    }
}

#Preview {
    PlannerSummaryView(
        viewModel: PlannerSummaryViewModel(
            project: Project(
                name: "Sample Project",
                type: .iOSApp,
                discoverySession: DiscoverySession(
                    answers: DiscoveryQuestion.all.map {
                        DiscoveryAnswer(
                            questionID: $0.id,
                            prompt: $0.prompt,
                            category: $0.category,
                            response: "Preview answer"
                        )
                    }
                )
            ),
            projectRepository: PreviewProjectRepository()
        )
    )
}
