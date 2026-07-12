import Foundation
import Combine

@MainActor
final class DiscoverySessionViewModel: ObservableObject {
    enum Mode {
        case questions
        case review
    }

    @Published private(set) var mode: Mode = .questions
    @Published private(set) var currentQuestionIndex = 0
    @Published var currentResponse = ""
    @Published private(set) var validationMessage: String?
    @Published private(set) var errorMessage: String?

    let questions: [DiscoveryQuestion]

    private var project: Project
    private let projectRepository: ProjectRepository
    private var responses: [String: String]
    private var isEditingFromReview = false

    init(
        project: Project,
        projectRepository: ProjectRepository,
        questions: [DiscoveryQuestion] = DiscoveryQuestion.all
    ) {
        self.project = project
        self.projectRepository = projectRepository
        self.questions = questions
        responses = Dictionary(
            uniqueKeysWithValues: project.discoverySession?.answers.map {
                ($0.questionID, $0.response)
            } ?? []
        )
        currentResponse = responses[questions.first?.id ?? ""] ?? ""

        if project.discoverySession != nil {
            mode = .review
        }
    }

    var currentQuestion: DiscoveryQuestion {
        questions[currentQuestionIndex]
    }

    var questionProgressText: String {
        "Question \(currentQuestionIndex + 1) of \(questions.count)"
    }

    var completionPercentage: Int {
        Int((Double(currentQuestionIndex + 1) / Double(questions.count) * 100).rounded())
    }

    var progressValue: Double {
        Double(currentQuestionIndex + 1) / Double(questions.count)
    }

    var canMoveBack: Bool {
        currentQuestionIndex > 0
    }

    var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }

    var answers: [DiscoveryAnswer] {
        questions.map { question in
            DiscoveryAnswer(
                questionID: question.id,
                prompt: question.prompt,
                category: question.category,
                response: responses[question.id] ?? ""
            )
        }
    }

    func selectOption(_ option: String) {
        currentResponse = option
        validationMessage = nil
    }

    func moveBack() {
        saveCurrentResponse()

        guard canMoveBack else {
            return
        }

        currentQuestionIndex -= 1
        loadCurrentResponse()
    }

    func moveForward() {
        guard validateCurrentResponse() else {
            return
        }

        saveCurrentResponse()

        if isEditingFromReview, allQuestionsAnswered {
            isEditingFromReview = false
            mode = .review
        } else if isLastQuestion {
            mode = .review
        } else {
            currentQuestionIndex += 1
            loadCurrentResponse()
        }
    }

    func editAnswer(_ answer: DiscoveryAnswer) {
        guard let index = questions.firstIndex(where: { $0.id == answer.questionID }) else {
            return
        }

        mode = .questions
        currentQuestionIndex = index
        isEditingFromReview = true
        loadCurrentResponse()
    }

    func confirmCompletion() async -> Project? {
        let now = Date()
        project.discoverySession = DiscoverySession(
            answers: answers,
            completedAt: project.discoverySession?.completedAt ?? now,
            updatedAt: now
        )

        do {
            try await projectRepository.save(project)
            errorMessage = nil
            return project
        } catch {
            errorMessage = "Discovery session could not be saved."
            return nil
        }
    }

    func clearError() {
        errorMessage = nil
    }

    private func loadCurrentResponse() {
        currentResponse = responses[currentQuestion.id] ?? ""
        validationMessage = nil
    }

    private func saveCurrentResponse() {
        responses[currentQuestion.id] = trimmedCurrentResponse
    }

    private func validateCurrentResponse() -> Bool {
        guard !trimmedCurrentResponse.isEmpty else {
            validationMessage = "Add an answer before continuing."
            return false
        }

        validationMessage = nil
        return true
    }

    private var trimmedCurrentResponse: String {
        currentResponse.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var allQuestionsAnswered: Bool {
        questions.allSatisfy {
            !(responses[$0.id] ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
}
