//
// Created by Michael Lustig on 12/2/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

struct Duration {
    let start: Int
    let end: Int
    let formattedStart: String
    let formattedEnd: String

    init(start: Int, end: Int = 0) {
        self.start = start
        self.end = end
        formattedStart = TimeFormatter.formatDuration(start)
        formattedEnd = TimeFormatter.formatDuration(end)
    }
}
