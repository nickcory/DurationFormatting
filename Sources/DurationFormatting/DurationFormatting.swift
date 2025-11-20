//
//  DurationFormatter.swift
//  DurationFormatting
//
//  Created by Nick Cory on 11/19/25.
//

import Foundation

public enum DurationFormatStyle {
    case positional      // e.g. "1:03:05" or "03:05"
    case short           // e.g. "1d 2h 3m 4s"
    case long            // e.g. "1 day, 2 hours, 3 minutes, 4 seconds"
}

public struct DurationFormatting {
    public var style: DurationFormatStyle
    /// Maximum number of time units to display, e.g. 2 -> "1h 3m"
    public var maximumUnits: Int
    /// For non-positional styles: whether seconds should be included as a potential unit.
    public var includesSeconds: Bool
    
    public init(
        style: DurationFormatStyle = .short,
        maximumUnits: Int = 3,
        includesSeconds: Bool = true
    ) {
        self.style = style
        self.maximumUnits = max(1, maximumUnits)
        self.includesSeconds = includesSeconds
    }
    
    /// Formats a duration expressed in seconds.
    public func string(from seconds: TimeInterval) -> String {
        // Normalize to whole seconds.
        let totalSeconds = Int(seconds.rounded())
        let isNegative = totalSeconds < 0
        let absSeconds = abs(totalSeconds)
        
        let result: String
        switch style {
        case .positional:
            result = positionalString(from: absSeconds)
        case .short:
            result = componentsString(from: absSeconds, longUnits: false)
        case .long:
            result = componentsString(from: absSeconds, longUnits: true)
        }
        return isNegative ? "-\(result)" : result
    }
}

// MARK: - Private helpers

private extension DurationFormatting {
    /// Returns strings like "03:05" or "1:03:05"
    func positionalString(from totalSeconds: Int) -> String {
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        
        if hours > 0 {
            // H:MM:SS (hours can be more than 24)
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            // M:SS
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
    
    /// Builds "1d 2h 3m 4s" (short) or "1 day, 2 hours, 3 minutes, 4 seconds" (long)
    func componentsString(from totalSeconds: Int, longUnits: Bool) -> String {
        if totalSeconds == 0 {
            return longUnits ? "0 seconds" : "0s"
        }
        
        let secondsInMinute = 60
        let secondsInHour = secondsInMinute * 60
        let secondsInDay = secondsInHour * 24

        
        var remaining = totalSeconds
        
        let days = remaining / secondsInDay
        remaining %= secondsInDay
        
        let hours = remaining / secondsInHour
        remaining %= secondsInHour
        
        let minutes = remaining / secondsInMinute
        remaining %= secondsInMinute
        
        let seconds = remaining
        
        var parts: [(value: Int, short: String, longSingular: String, longPlural: String)] = []
        
        if days > 0 {
            parts.append((days, "d", "day", "days"))
        }
        if hours > 0 {
            parts.append((hours, "h", "hour", "hours"))
        }
        if minutes > 0 {
            parts.append((minutes, "m", "minute", "minutes"))
        }
        if includesSeconds && seconds > 0 {
            parts.append((seconds, "s", "second", "seconds"))
        }
        
        // If everything was zero except seconds and we excluded seconds, fall back to "0s" / "0 seconds".
        if parts.isEmpty {
            return longUnits ? "0 seconds" : "0s"
        }
        
        // Respect maximumUnits
        let limitedParts = parts.prefix(maximumUnits)
        
        if longUnits {
            let strings = limitedParts.map { part -> String in
                let unit = (part.value == 1) ? part.longSingular : part.longPlural
                return "\(part.value) \(unit)"
            }
            return joinLongComponents(strings)
        } else {
            return limitedParts.map { "\($0.value)\($0.short)" }.joined(separator: " ")
        }
    }
    
    /// Joins ["1 hour", "2 minutes", "3 seconds"] into "1 hour, 2 minutes, and 3 seconds"
    func joinLongComponents(_ components: [String]) -> String {
        guard !components.isEmpty else { return "" }
        if components.count == 1 { return components[0] }
        if components.count == 2 { return components.joined(separator: " and ") }
        
        let allButLast = components.dropLast().joined(separator: ", ")
        let last = components.last!
        return "\(allButLast), and \(last)"
    }
}

public extension TimeInterval {
    
    func formattedDuration (
        style: DurationFormatStyle = .short,
        maximumUnits: Int = 3,
        includesSeconds: Bool = true
    ) -> String {
        let formatter = DurationFormatting(
            style: style,
            maximumUnits: maximumUnits,
            includesSeconds: includesSeconds
        )
        return formatter.string(from: self)
    }
    
}
