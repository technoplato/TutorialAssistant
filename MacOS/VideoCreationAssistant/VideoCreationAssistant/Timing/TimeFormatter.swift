//
// Created by Michael Lustig on 12/2/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import Foundation

class TimeFormatter {
    public static func formatDuration(_ duration: Int) -> String {
        let seconds = duration % 60
        let minutes = (duration / 60) % 60
        let hours = (duration / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
