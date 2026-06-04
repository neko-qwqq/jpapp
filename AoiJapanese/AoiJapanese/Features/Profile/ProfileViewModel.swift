import Foundation
import Observation

@Observable
final class ProfileViewModel {
    var profile: UserProfile
    var achievements: [Achievement]

    init(
        profile: UserProfile = MockData.profile,
        achievements: [Achievement] = MockData.achievements
    ) {
        self.profile = profile
        self.achievements = achievements
    }

    var courseCompletionText: String {
        "\(profile.completedLessons)/\(profile.totalLessons)"
    }

    var totalHoursText: String {
        let hours = Double(profile.totalStudyMinutes) / 60.0
        return String(format: "%.1f h", hours)
    }
}
