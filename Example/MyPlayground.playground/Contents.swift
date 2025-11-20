import Cocoa
import DurationFormatting

let f = DurationFormatting(style: .short)
print(f.string(from: 3661)) //1h 1m 1s

let f2 = DurationFormatting(style: .long)
print(f2.string(from: 3661))

let f3 = DurationFormatting(style: .positional)
print(f3.string(from: 3661))


//TimeInterval Extension
let duration: TimeInterval = 3661

duration.formattedDuration()
duration.formattedDuration(style: .long)
duration.formattedDuration(style: .positional)
duration.formattedDuration(style: .long, maximumUnits: 2)
