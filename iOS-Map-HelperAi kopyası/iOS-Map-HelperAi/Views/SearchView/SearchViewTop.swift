//
//  SearchViewTop.swift
//  AI-HelperMap
//
//  Created by Erkin Arikan on 5.09.2024.
//

import SwiftUI

struct SearchViewTop: View {
    @Binding var endingOffSetY:CGFloat
    @Binding var isSearchViewShow:Bool
    @EnvironmentObject var vm:MapViewModel
    
    var body: some View {
        HStack {
            Spacer()
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 60, height: 4)
                .padding(.top, 4)
                .foregroundStyle(Color(.systemGray2))
            Spacer()

           
        }
        .padding(.top)
        
    }
}

