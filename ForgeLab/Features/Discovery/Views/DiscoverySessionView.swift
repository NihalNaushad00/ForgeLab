import SwiftUI

struct DiscoverySessionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: DiscoverySessionViewModel
    @State private var isSaving = false

    let onCompletion: (Project) -> Void

    init(
        viewModel: DiscoverySessionViewModel,
        onCompletion: @escaping (Project) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onCompletion = onCompletion
    }

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.mode {
                case .questions:
                    questionView
                case .review:
                    DiscoveryReviewView(
                        answers: viewModel.answers,
                        isSaving: isSaving,
                        onEdit: viewModel.editAnswer
                    ) {
                        Task {
                            await confirmDiscovery()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .alert(
                "Discovery Error",
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

    private var questionView: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text(viewModel.questionProgressText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ProgressView(value: viewModel.progressValue)

                Text("\(viewModel.completionPercentage)% Complete")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.currentQuestion.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(viewModel.currentQuestion.prompt)
                    .font(.title2)
                    .fontWeight(.semibold)
            }

            responseInput

            if let validationMessage = viewModel.validationMessage {
                Text(validationMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            Spacer()

            HStack {
                Button {
                    viewModel.moveBack()
                } label: {
                    Label("Back", systemImage: "chevron.left")
                }
                .disabled(!viewModel.canMoveBack)

                Spacer()

                Button {
                    viewModel.moveForward()
                } label: {
                    Label(
                        viewModel.isLastQuestion ? "Review" : "Next",
                        systemImage: viewModel.isLastQuestion ? "list.bullet.rectangle" : "chevron.right"
                    )
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .navigationTitle("Discovery")
    }

    @ViewBuilder
    private var responseInput: some View {
        switch viewModel.currentQuestion.responseKind {
        case .text:
            TextField("Answer", text: $viewModel.currentResponse)
                .textFieldStyle(.roundedBorder)
        case .multiline:
            TextField("Answer", text: $viewModel.currentResponse, axis: .vertical)
                .lineLimit(5...10)
                .textFieldStyle(.roundedBorder)
        case .singleChoice(let options):
            VStack(alignment: .leading, spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button {
                        viewModel.selectOption(option)
                    } label: {
                        HStack {
                            Text(option)
                            Spacer()
                            if viewModel.currentResponse == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    private func confirmDiscovery() async {
        isSaving = true
        defer { isSaving = false }

        if let project = await viewModel.confirmCompletion() {
            onCompletion(project)
            dismiss()
        }
    }
}

#Preview {
    DiscoverySessionView(
        viewModel: DiscoverySessionViewModel(
            project: Project(name: "Sample Project", type: .iOSApp),
            projectRepository: PreviewProjectRepository()
        ),
        onCompletion: { _ in }
    )
}
