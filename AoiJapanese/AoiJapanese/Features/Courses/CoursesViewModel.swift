import Foundation
import Observation

@Observable
final class CoursesViewModel {
    var courses: [CourseUnit]
    var selectedLevel: JLPTLevel?

    init(courses: [CourseUnit] = MockData.courses, selectedLevel: JLPTLevel? = nil) {
        self.courses = courses
        self.selectedLevel = selectedLevel
    }

    var visibleCourses: [CourseUnit] {
        guard let selectedLevel else { return courses.sorted { $0.order < $1.order } }
        return courses
            .filter { $0.level == selectedLevel }
            .sorted { $0.order < $1.order }
    }

    var totalProgress: Double {
        guard !courses.isEmpty else { return 0 }
        return courses.map(\.progress).reduce(0, +) / Double(courses.count)
    }
}
