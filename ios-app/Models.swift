import SwiftUI

struct ContentView: View {
    // Сохранение выбранной темы в память устройства: "system", "light", "dark"
    @AppStorage("selectedTheme") private var selectedTheme: String = "system"

    var body: some View {
        TabView {
            // Вкладка 1: Главная
            NavigationView {
                VStack(spacing: 20) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("AirCard Custom")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Вкладка карт успешно удалена.\nТеперь здесь ваше кастомное приложение.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .navigationTitle("Главная")
            }
            .tabItem {
                Label("Главная", systemImage: "creditcard")
            }

            // Вкладка 2: Настройки с переключением тем оформления
            NavigationView {
                Form {
                    Section(header: Text("Внешний вид")) {
                        Picker("Тема оформления", selection: $selectedTheme) {
                            Text("Системная").tag("system")
                            Text("Светлая").tag("light")
                            Text("Тёмная").tag("dark")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("О приложении")) {
                        HStack {
                            Text("Версия")
                            Spacer()
                            Text("1.0.0 (GitHub Build)")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("Настройки")
            }
            .tabItem {
                Label("Настройки", systemImage: "gearshape")
            }
        }
        // Применяем выбранную цветовую схему ко всему приложению
        .preferredColorScheme(colorSchemeForTheme(selectedTheme))
    }

    // Вспомогательная функция для переключения цветовой темы
    private func colorSchemeForTheme(_ theme: String) -> ColorScheme? {
        switch theme {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil // Системная тема
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
