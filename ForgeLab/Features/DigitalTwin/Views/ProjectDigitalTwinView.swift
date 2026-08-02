import SwiftUI

struct ProjectDigitalTwinView: View {
    @StateObject private var viewModel: ProjectDigitalTwinViewModel

    init(viewModel: ProjectDigitalTwinViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        let twin = viewModel.digitalTwin

        List {
            Section("Project Summary") {
                VStack(alignment: .leading, spacing: 8) {
                    Text(twin.projectInformation.name)
                        .font(.headline)

                    Text(summaryText)
                        .foregroundStyle(.secondary)
                }

                LabeledContent("Type", value: twin.projectInformation.type)
                LabeledContent("Status", value: twin.currentStatus)
            }

            Section("Discovery Summary") {
                if twin.discoveryAnswers.isEmpty {
                    Text("Discovery has not been completed.")
                        .foregroundStyle(.secondary)
                } else {
                    LabeledContent("Answers", value: "\(twin.discoveryAnswers.count)")

                    ForEach(twin.discoveryAnswers.prefix(3)) { answer in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(answer.prompt)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(answer.response)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }

            Section("Planner Summary") {
                if let plannerOutput = twin.plannerOutput {
                    Text(plannerOutput.summary)
                    LabeledContent("Features", value: "\(plannerOutput.featureCount)")
                    LabeledContent("Milestones", value: "\(plannerOutput.milestoneCount)")
                    LabeledContent(
                        "Generated",
                        value: DateFormatter.forgeLabProjectDate.string(from: plannerOutput.generatedAt)
                    )
                } else {
                    Text("No Product Specification has been generated.")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Current Progress") {
                ProgressView(value: Double(twin.progress.completionPercentage), total: 100)

                LabeledContent(
                    "Complete",
                    value: "\(twin.progress.completionPercentage)%"
                )
                LabeledContent(
                    "Steps",
                    value: "\(twin.progress.completedSteps) of \(twin.progress.totalSteps)"
                )
            }

            Section("Coding Agent") {
                if let codingSummary = twin.codingSummary {
                    LabeledContent("Status", value: codingSummary.status)
                    LabeledContent("Work Packages", value: "\(codingSummary.workPackageCount)")
                    LabeledContent("Tasks", value: "\(codingSummary.taskCount)")
                    LabeledContent("Pending", value: "\(codingSummary.pendingTaskCount)")
                    LabeledContent("In Progress", value: "\(codingSummary.inProgressTaskCount)")
                    LabeledContent("Completed", value: "\(codingSummary.completedTaskCount)")
                    LabeledContent("Future", value: "\(codingSummary.futureTaskCount)")
                } else {
                    Text("Coding Agent workflow has not been generated.")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Current Milestone") {
                Text(twin.currentMilestone)
            }

            Section("Last Updated") {
                LabeledContent(
                    "Twin Updated",
                    value: DateFormatter.forgeLabProjectDate.string(from: twin.lastUpdated)
                )
                LabeledContent(
                    "Project Modified",
                    value: DateFormatter.forgeLabProjectDate.string(from: twin.projectInformation.updatedAt)
                )
            }
        }
        .navigationTitle("Project Digital Twin")
    }

    private var summaryText: String {
        let summary = viewModel.digitalTwin.projectInformation.summary
        return summary.isEmpty ? "No project description has been added." : summary
    }
}

#Preview {
    ProjectDigitalTwinView(
        viewModel: ProjectDigitalTwinViewModel(
            project: Project(
                name: "Sample Project",
                summary: "A preview project for SwiftUI canvas rendering.",
                type: .iOSApp
            )
        )
    )
}
