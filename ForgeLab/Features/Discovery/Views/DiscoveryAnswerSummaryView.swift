import SwiftUI

struct DiscoveryAnswerSummaryView: View {
    let answer: DiscoveryAnswer
    let onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(answer.category)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(answer.prompt)
                        .font(.headline)
                }

                Spacer()

                Button("Edit", action: onEdit)
                    .buttonStyle(.bordered)
            }

            Text(answer.response)
                .font(.body)
                .foregroundStyle(answer.response.isEmpty ? .secondary : .primary)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    DiscoveryAnswerSummaryView(
        answer: DiscoveryAnswer(
            questionID: "platform",
            prompt: "Which platform are you targeting?",
            category: "Platform",
            response: "iOS"
        ),
        onEdit: {}
    )
}
