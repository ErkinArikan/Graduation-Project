import SwiftUI

struct TabBarView1: View {
    @Binding var isShow: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
                .shadow(color: .gray.opacity(0.4), radius: 20, x: 0, y: 20)
            
            TabsLayoutView(isShow: $isShow)
        }
        .frame(height: 70, alignment: .center)
    }
}

private struct TabsLayoutView: View {
    @State var selectedTab: Tab = .search
    @Namespace var namespace
    @Binding var isShow: Bool
    
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            
            ForEach(Tab.allCases) { tab in
                TabButton(tab: tab, selectedTab: $selectedTab, namespace: namespace, isShow: $isShow)
                    .frame(width: 80, height: 70, alignment: .center)
                
                Spacer(minLength: 0)
            }
        }
    }
    
    private struct TabButton: View {
        let tab: Tab
        @Binding var selectedTab: Tab
        var namespace: Namespace.ID
        @Binding var isShow: Bool
        
        var body: some View {
            Button {
                withAnimation {
                    selectedTab = tab
                    if tab == .search {  // Yalnızca seçili sekme "search" ise isShow'u tetikleyin
                        isShow.toggle()
                    }
                }
            } label: {
                ZStack {
                    if isSelected {
                        Circle()
                            .shadow(radius: 10)
                            .background {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .foregroundColor(backgroundColor)
                            }
                            .offset(y: -40)
                            .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                            .animation(.spring(), value: selectedTab)
                        
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .foregroundColor(isSelected ? .init(white: 0.9) : .gray)
                        .scaleEffect(isSelected ? 1 : 0.8)
                        .offset(y: isSelected ? -40 : 0)
                        .animation(isSelected ? .spring(response: 0.5, dampingFraction: 0.3, blendDuration: 1) : .spring(), value: selectedTab)
                }
            }
            .buttonStyle(.plain)
        }
        
        private var isSelected: Bool {
            selectedTab == tab
        }
    }
}

#Preview {
    TabBarView1(isShow: .constant(false))
        .padding(.horizontal)
}
