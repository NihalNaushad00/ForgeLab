import SwiftUI

struct ProjectFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ProjectFormViewModel

    let onSave: (Project) -> Void

    init(
        viewModel: ProjectFormViewModel,
        onSave: @escaping (Project) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Project") {
                    TextField("Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.summary, axis: .vertical)
                        .lineLimit(3...6)

                    Picker("Type", selection: $viewModel.type) {
                        ForEach(ProjectType.allCases) { type in
                            Text(type.displayName)
                                .tag(type)
                        }
                    }
                }

                if let validationMessage = viewModel.validationMessage {
                    Section {
                        Text(validationMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(viewModel.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(viewModel.primaryActionTitle) {
                        if let project = viewModel.makeProject() {
                            onSave(project)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProjectFormView(viewModel: ProjectFormViewModel()) { _ in }
}
