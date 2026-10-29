import SwiftUI

struct MenuView: View {
    @State private var isActivated = UserDefaults.standard.bool(forKey: "AIMLD_Activated")
    @State private var keyInput = ""
    @State private var errorMsg = ""
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.85).ignoresSafeArea()
            if !isActivated {
                VStack(spacing: 15) {
                    Text("AIMLD").font(.largeTitle).bold().foregroundColor(.purple)
                    Text("Nhập Key Để Kích Hoạt").foregroundColor(.gray)
                    TextField("AIMLD-XXXX-XXXX", text: $keyInput)
                        .padding().background(Color.gray.opacity(0.3))
                        .cornerRadius(8).foregroundColor(.white).autocapitalization(.allCharacters)
                    
                    Button("Kích Hoạt") {
                        AuthManager.shared().validateKey(keyInput) { success, isAdmin in
                            if success { isActivated = true } else { errorMsg = "Sai Key!" }
                        }
                    }.padding().frame(maxWidth: .infinity)
                        .background(Color.purple).cornerRadius(8).foregroundColor(.white)
                    
                    if !errorMsg.isEmpty { Text(errorMsg).foregroundColor(.red) }
                }.padding()
            } else {
                VStack {
                    HStack {
                        Text("AIMLD Menu").foregroundColor(.purple).bold()
                        Spacer()
                        if UserDefaults.standard.bool(forKey: "AIMLD_Admin") {
                            Text("ADMIN").padding(4).background(Color.red)
                                .cornerRadius(4).foregroundColor(.white).font(.caption)
                        }
                    }.padding()
                    Text("ESP • Aimbot • FastFire").foregroundColor(.gray)
                }
            }
        }
    }
}

@objc public class MenuController: NSObject {
    @objc public static func getView() -> UIViewController {
        return UIHostingController(rootView: MenuView())
    }
}