import SwiftUI

struct DiscoveryReviewView: View {
    let answers: [DiscoveryAnswer]
    let isSaving: Bool
    let onEdit: (DiscoveryAnswer) -> Void
    let onConfirm: () -> Void

    var body: some View {
        List {
            Section {
                Text("Review the discovery answers before saving them with this project.")
                    .foregroundStyle(.secondary)
            }

            Section("Discovery Summary") {
                ForEach(answers) { answer in
                    DiscoveryAnswerSummaryView(answer: answer) {
                        onEdit(answer)
                    }
                }
            }

            Section {
                Button {
                    onConfirm()
                } label: {
                    if isSaving {
                        ProgressView()
                    } else {
                        Label("Confirm Discovery", systemImage: "checkmark.circle")
                    }
                }
                .disabled(isSaving)
            }
        }
        .navigationTitle("Review")
    }
}

#Preview {
    NavigationStack {
        DiscoveryReviewView(
            answers: [
                DiscoveryAnswer(
                    questionID: "goal",
                    prompt: "What are you building?",
                    category: "Project Basics",
                    response: "A study planning app."
                )
            ],
            isSaving: false,
            onEdit: { _ in },
            onConfirm: {}
        )
    }
}
