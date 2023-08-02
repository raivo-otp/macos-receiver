//
// Raivo OTP
//
// Copyright (c) 2023 Mobime. All rights reserved. Raivo OTP
// is provided 'as-is', without any express or implied warranty.
//
// Modification, duplication or distribution of this software (in
// source and binary forms) for any purpose is strictly prohibited.
//
// https://github.com/raivo-otp/macos-receiver/blob/master/LICENSE.md
//

import Foundation
import SwiftUI

/// A background for a horizontal (landscape) QR-code view
struct QuickResponseCodeBackground: View {
    
    /// The actual background view
    var body: some View {
        ZStack {
            ForEach((4...15), id: \.self) { index in
                Circle()
                    .strokeBorder(Color.accentColor.opacity(0.035), lineWidth: 7.5)
                    .frame(width: CGFloat(index * 75), height: CGFloat(index * 75))
                    .zIndex(Double(index))
            }
        }
    }
    
}

#if DEBUG
struct QuickResponseCodeBackground_Previews: PreviewProvider {
    
    static var previews: some View {
        QuickResponseCodeBackground()
    }
    
}
#endif

