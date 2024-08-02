//
//  View+If.swift
//  InterviewProject
//
//  Created by Cameron Taylor on 8/1/24.
//

import Foundation
import SwiftUI

extension View {
    /// Applies the given modifier conditionally.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transformation to apply if the condition is true.
    /// - Returns: Either the original view or the modified view.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
