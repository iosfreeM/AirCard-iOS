import SwiftUI
import UIKit
import PhotosUI
import UniformTypeIdentifiers

// MARK: - Shared helpers

func logLineColor(_ line: String) -> Color {
    if line.contains("✅") || line.contains("🎉") { return .green }
    if line.contains("❌") { return .red }
    if line.contains("⚠️") { return .orange }
    return .secondary
}

// MARK: - Share Sheet for Exporting .passthm

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Crypto Donation Row

struct CryptoDonationRow: View {
    let title: String
    let address: String
    let icon: String
    let iconColor: Color

    @State private var isCopied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
                    .font(.subheadline.bold())
                Text(title)
                    .font(.subheadline.bold())
                Spacer()
                Button {
                    UIPasteboard.general.string = address
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isCopied = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            isCopied = false
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: isCopied ? "checkmark" : "doc.on.doc.fill")
                        Text(isCopied ? "Copied!" : "Copy")
                    }
                    .font(.caption.bold())
                    .foregroundStyle(isCopied ? .green : .accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(isCopied ? Color.green.opacity(0.12) : Color.accentColor.opacity(0.12))
                    .clipShape(Capsule())
                }
            }

            Text(address)
                .font(.system(.caption2, design: .monospaced))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .textSelection(.enabled)
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Donate View

struct DonateView: View {
    var isPopup: Bool = false
    var onDismiss: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.pink)

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text("Maksym Reva")
                                .font(.headline.bold())
                            Text("🇺🇦")
                                .font(.subheadline)
                        }
                        Text("@mak5er • Lead & Core Developer")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }

                HStack(spacing: 10) {
                    Link(destination: URL(string: "https://x.com/mak5er")!) {
                        HStack(spacing: 5) {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                            Text("Twitter / X")
                        }
                        .font(.caption.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.accentColor.opacity(0.12))
                        .foregroundStyle(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    Link(destination: URL(string: "https://github.com/mak5er")!) {
                        HStack(spacing: 5) {
                            Image(systemName: "link")
                            Text("GitHub")
                        }
                        .font(.caption.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.primary.opacity(0.08))
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
            .padding(16)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 10) {
                Text("Donate & Support")
                    .font(.caption.bold().uppercaseSmallCaps())
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)

                Link(destination: URL(string: "https://www.paypal.com/donate/?hosted_button_id=98QRTC2HFRA4Y")!) {
                    HStack(spacing: 10) {
                        Image(systemName: "creditcard.fill")
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Donate with PayPal")
                                .font(.subheadline.bold())
                            Text("Recipient: Maksym Reva")
                                .font(.caption2)
                                .opacity(0.85)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right.square.fill")
                            .font(.subheadline)
                    }
                    .padding(14)
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            colors: [Color.accentColor, Color.accentColor.opacity(0.75)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }

                CryptoDonationRow(
                    title: "💎 TON (The Open Network)",
                    address: "UQBm9KPhtMw-XVVjirUoa09wzrlyWsbeZhKfefl1Uw-qNZ-r",
                    icon: "diamond.fill",
                    iconColor: .cyan
                )

                CryptoDonationRow(
                    title: "💵 USDT (TRC20)",
                    address: "TDkDMCyjYxgvkWUnQiF5Erk2RyPQMT6G1n",
                    icon: "dollarsign.circle.fill",
                    iconColor: .green
                )

                CryptoDonationRow(
                    title: "🪙 BEP20 (BNB / USDT)",
                    address: "0x0954dc491c502849d04956ef74634aa5931a08e8",
                    icon: "bitcoinsign.circle.fill",
                    iconColor: .orange
                )
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Support Popup Sheet

struct SupportPopupSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var dontShowOnLaunch: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    VStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 52))
                            .foregroundStyle(Color.accentColor)

                        Text("Welcome to AirCard Custom")
                            .font(.title2.bold())

                        Text("Passcode Themes & Wallpapers Edition")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 8)

                    DonateView(isPopup: true, onDismiss: { dismiss() })

                    VStack(spacing: 12) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Continue")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }

                        Toggle(isOn: $dontShowOnLaunch) {
                            Text("Don't show this popup on startup")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 4)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
                .padding(.vertical)
            }
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }.bold()
                }
            }
        }
    }
}

// MARK: - Credits Sheet

struct CreditsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: Int

    init(initialTab: Int = 0) {
        _selectedTab = State(initialValue: initialTab)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Section", selection: $selectedTab) {
                    Text("Credits").tag(0)
                    Text("Donate ❤️").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 8)

                Divider()

                ScrollView {
                    if selectedTab == 0 {
                        creditsContent
                    } else {
                        VStack(spacing: 20) {
                            DonateView()
                            Spacer(minLength: 20)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle(selectedTab == 0 ? "Credits" : "Donate & Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }.bold()
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    @ViewBuilder
    private var creditsContent: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Image(systemName: "paintbrush.pointed.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Color.accentColor)

                Text("AirCard Custom")
                    .font(.title2.bold())

                Text("Passcode Themes & Wallpapers (iOS 18.0 – 27.2 b2)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 10)

            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label("Lead & Core Developer", systemImage: "crown.fill")
                            .font(.caption.bold().uppercaseSmallCaps())
                            .foregroundStyle(.orange)
                        Spacer()
                    }
                    HStack {
                        Text("@mak5er").font(.headline.bold())
                        Spacer()
                        Link("GitHub", destination: URL(string: "https://github.com/mak5er")!)
                            .font(.caption.bold())
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                    }
                }
                .padding(14)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label("Base IPA Developer", systemImage: "hammer.fill")
                            .font(.caption.bold().uppercaseSmallCaps())
                            .foregroundStyle(.blue)
                        Spacer()
                    }
                    HStack {
                        Text("@merybist").font(.headline.bold())
                        Spacer()
                        Link("GitHub", destination: URL(string: "https://github.com/merybist")!)
                            .font(.caption.bold())
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                    }
                }
                .padding(14)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal)

            Spacer(minLength: 20)
        }
        .padding(.vertical)
    }
}

// MARK: - Pairing File Guide Sheet

struct PairingGuideSheet: View {
    @Environment(\.dismiss) private var dismiss
    var onImportTapped: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Where to find your pairing file")
                            .font(.title2.bold())
                        Text("Import pairing files exported by SideStore, LiveContainer, iLoader, or your computer.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "app.badge.checkmark.fill")
                                .font(.title3)
                                .foregroundStyle(Color.accentColor)
                            Text("SideStore")
                                .font(.headline.bold())
                            Spacer()
                            Text("Recommended")
                                .font(.caption2.bold())
                                .padding(.horizontal, 8).padding(.vertical, 3)
                                .background(Color.accentColor.opacity(0.15))
                                .foregroundStyle(Color.accentColor)
                                .clipShape(Capsule())
                        }

                        Text("On My iPhone › SideStore › ALTPairingFile.mobiledevicepairing")
                            .font(.caption.monospaced())
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(uiColor: .systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "shippingbox.fill")
                                .font(.title3)
                                .foregroundStyle(.purple)
                            Text("LiveContainer")
                                .font(.headline.bold())
                        }

                        Text("On My iPhone › LiveContainer › SideStore › Documents › ALTPairingFile.mobiledevicepairing")
                            .font(.caption.monospaced())
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(uiColor: .systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    Button {
                        dismiss()
                        onImportTapped()
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "square.and.arrow.down.fill")
                            Text("Import Pairing File Now")
                            Spacer()
                        }
                        .font(.headline)
                        .frame(height: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 4)
                }
                .padding()
            }
            .navigationTitle("Pairing Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }.bold()
                }
            }
        }
    }
}

// MARK: - Compact Scrollable Log View

struct CompactLogView: View {
    let title: String
    let lines: [String]
    var onClear: (() -> Void)? = nil
    @State private var copied: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Spacer()
                if let onClear = onClear, !lines.isEmpty {
                    Button(action: onClear) {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.borderless)
                    .padding(.trailing, 6)
                }
                Button {
                    UIPasteboard.general.string = lines.joined(separator: "\n")
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    copied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        copied = false
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 11, weight: .bold))
                        Text(copied ? "Copied" : "Copy")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundStyle(copied ? .green : .accentColor)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Color(uiColor: .tertiarySystemFill))
                    .clipShape(Capsule())
                }
                .buttonStyle(.borderless)
            }

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 2) {
                        ForEach(Array(lines.enumerated()), id: \.offset) { idx, line in
                            Text(line)
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundStyle(logLineColor(line))
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id(idx)
                        }
                    }
                    .padding(10)
                }
                .frame(maxHeight: 180)
                .background(Color(uiColor: .tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.secondary.opacity(0.18), lineWidth: 0.5)
                )
                .onChange(of: lines.count) { _, _ in
                    if !lines.isEmpty {
                        proxy.scrollTo(lines.count - 1, anchor: .bottom)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Native Document Picker

struct DocumentPickerView: UIViewControllerRepresentable {
    let allowedContentTypes: [UTType]
    let onPick: (URL) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: allowedContentTypes, asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPickerView

        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            let shouldStop = url.startAccessingSecurityScopedResource()
            defer {
                if shouldStop { url.stopAccessingSecurityScopedResource() }
            }
            parent.onPick(url)
            parent.dismiss()
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.dismiss()
        }
    }
}

// MARK: - Root Tab View (Без вкладки Wallet Cards + новая вкладка Настройки)

struct ContentView: View {
    @EnvironmentObject var vm: AppViewModel
    @AppStorage("aircard.dont_show_support_on_launch") private var dontShowSupportOnLaunch: Bool = false
    @AppStorage("app.selected_theme") private var selectedThemeRaw: String = AppThemeOption.system.rawValue
    @AppStorage("app.selected_accent") private var selectedAccentRaw: String = AppAccentOption.purple.rawValue
    @State private var showSupportPopup: Bool = false

    private var currentTheme: AppThemeOption {
        AppThemeOption(rawValue: selectedThemeRaw) ?? .system
    }

    private var currentAccent: AppAccentOption {
        AppAccentOption(rawValue: selectedAccentRaw) ?? .purple
    }

    var body: some View {
        TabView(selection: $vm.selectedTab) {
            PairingTab()
                .tabItem { Label("Pairing", systemImage: "antenna.radiowaves.left.and.right") }
                .tag(AppTab.pairing)

            PasscodeThemeTab()
                .tabItem { Label("Passcode", systemImage: "lock.circle.fill") }
                .tag(AppTab.passcodeThemes)

            TendiesView()
                .tabItem { Label("Wallpapers", systemImage: "photo.stack.fill") }
                .tag(AppTab.wallpapers)

            SettingsTab()
                .tabItem { Label("Настройки", systemImage: "gearshape.fill") }
                .tag(AppTab.settings)
        }
        .tint(currentAccent.color)
        .preferredColorScheme(currentTheme.colorScheme)
        .alert("Notice", isPresented: Binding(
            get: { vm.errorMessage != nil },
            set: { if !$0 { vm.errorMessage = nil } }
        )) {
            Button("OK") { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
        .alert("Success! 🎉", isPresented: $vm.showSuccessAlert) {
            Button("OK") {}
        } message: {
            Text(vm.successAlertMessage)
        }
        .sheet(isPresented: $vm.showShareSheet) {
            if let url = vm.exportedThemeURL {
                ShareSheet(items: [url])
            }
        }
        .sheet(isPresented: $showSupportPopup) {
            SupportPopupSheet(dontShowOnLaunch: $dontShowSupportOnLaunch)
                .tint(currentAccent.color)
                .preferredColorScheme(currentTheme.colorScheme)
        }
        .onAppear {
            // Если по умолчанию стояла вкладка карт — переключаем на Pairing
            if vm.selectedTab == .walletCards {
                vm.selectedTab = .pairing
            }
            vm.showSuccessAlert = false
            vm.successAlertMessage = ""
            if !dontShowSupportOnLaunch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    showSupportPopup = true
                }
            }
        }
    }
}

// MARK: - Settings Tab (Новая вкладка настроек и смены тем оформления)

struct SettingsTab: View {
    @AppStorage("app.selected_theme") private var selectedThemeRaw: String = AppThemeOption.system.rawValue
    @AppStorage("app.selected_accent") private var selectedAccentRaw: String = AppAccentOption.purple.rawValue
    @AppStorage("aircard.dont_show_support_on_launch") private var dontShowSupportOnLaunch: Bool = false
    @State private var showCredits = false

    var body: some View {
        NavigationStack {
            Form {
                // Выбор светлой / тёмной / системной темы
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Тема оформления", systemImage: "circle.lefthalf.filled")
                            .font(.subheadline.bold())

                        Picker("Тема оформления", selection: $selectedThemeRaw) {
                            Text("Системная").tag(AppThemeOption.system.rawValue)
                            Text("Светлая").tag(AppThemeOption.light.rawValue)
                            Text("Тёмная").tag(AppThemeOption.dark.rawValue)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Внешний вид")
                } footer: {
                    Text("Выберите светлую или тёмную тему интерфейса, либо используйте настройки iOS.")
                }

                // Выбор акцентного цвета всего приложения
                Section("Акцентный цвет интерфейса") {
                    ForEach(AppAccentOption.allCases) { option in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedAccentRaw = option.rawValue
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        } label: {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(option.color)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                                    )

                                Text(accentLocalizedName(option))
                                    .foregroundStyle(.primary)

                                Spacer()

                                if selectedAccentRaw == option.rawValue {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(option.color)
                                        .font(.title3)
                                }
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Общие настройки
                Section("Общие") {
                    Toggle("Скрывать окно приветствия при запуске", isOn: $dontShowSupportOnLaunch)

                    Button {
                        showCredits = true
                    } label: {
                        HStack {
                            Label("Авторы и поддержка", systemImage: "heart.fill")
                                .foregroundStyle(.pink)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("О приложении") {
                    LabeledContent("Сборка", value: "Custom Edition")
                    LabeledContent("Поддержка iOS", value: "18.0 – 27.2 b2")
                }
            }
            .navigationTitle("Настройки")
            .sheet(isPresented: $showCredits) {
                CreditsSheet()
            }
        }
    }

    private func accentLocalizedName(_ option: AppAccentOption) -> String {
        switch option {
        case .blue: return "Синий (Ocean Blue)"
        case .purple: return "Фиолетовый (Royal Purple)"
        case .pink: return "Неоново-розовый (Neon Pink)"
        case .orange: return "Оранжевый (Sunset Orange)"
        case .green: return "Изумрудный (Emerald)"
        }
    }
}

// MARK: - Pairing Tab

struct PairingTab: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var showDeleteConfirm = false
    @State private var showCredits = false
    @State private var showFilePicker = false
    @State private var showPairingGuide = false

    private var isIOS27OrNewer: Bool {
        ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 27
    }

    private var isPotentiallyPatchedOS: Bool {
        let os = ProcessInfo.processInfo.operatingSystemVersion
        if os.majorVersion > 27 { return true }
        if os.majorVersion == 27 && os.minorVersion >= 3 { return true }
        return false
    }

    var body: some View {
        NavigationStack {
            Form {
                // Header
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 10) {
                            Image(systemName: "sparkles.rectangle.stack.fill")
                                .font(.title2)
                                .foregroundStyle(Color.accentColor)
                            Text("AirCard Custom")
                                .font(.title2.bold())
                            Spacer()
                            Text("iOS \(ProcessInfo.processInfo.operatingSystemVersion.majorVersion)")
                                .font(.caption.monospaced().bold())
                                .padding(.horizontal, 10).padding(.vertical, 4)
                                .background(Color.accentColor.opacity(0.15))
                                .foregroundStyle(Color.accentColor)
                                .clipShape(Capsule())
                        }
                        Text("Установка кастомных тем пароля и живых обоев без ПК. Поддерживаются iOS 18.0 – 27.2 beta 2.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        if isPotentiallyPatchedOS {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.orange)
                                Text("Обнаружена iOS 27.2 beta 3 или новее: эксплойт AirTraffic закрыт Apple в этой версии.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.vertical, 6)
                }

                // Network / VPN Status
                Section("Сеть и VPN") {
                    VPNStatusRow(vm: vm)
                }

                // Pairing Status
                Section("Статус Pairing") {
                    HStack(spacing: 10) {
                        if vm.hasPairingFile {
                            Image(systemName: "checkmark.seal.fill").foregroundStyle(.green)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Готово к работе ✅")
                                    .font(.subheadline.bold())
                                Text("\(vm.pairingFileName) (\(vm.pairingFileSizeString))")
                                    .font(.caption.monospaced())
                                    .foregroundStyle(.secondary)
                            }
                        } else {
                            Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(.orange)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Не подключено")
                                    .font(.subheadline.bold())
                                Text(isIOS27OrNewer
                                     ? "Выполните сопряжение ниже или импортируйте файл."
                                     : "Импортируйте pairing-файл из SideStore, iLoader или ПК.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        if vm.hasPairingFile {
                            Button(role: .destructive) {
                                showDeleteConfirm = true
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
                .confirmationDialog(
                    "Удалить pairing-файл?",
                    isPresented: $showDeleteConfirm,
                    titleVisibility: .visible
                ) {
                    Button("Удалить", role: .destructive) { vm.deletePairingFile() }
                    Button("Отмена", role: .cancel) {}
                }

                // Pairing File Import
                Section("Файл сопряжения (Pairing File)") {
                    VStack(alignment: .leading, spacing: 8) {
                        Button {
                            showFilePicker = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "square.and.arrow.down.fill")
                                    .foregroundStyle(Color.accentColor)
                                Text("Импортировать Pairing File…")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }

                        Button {
                            showPairingGuide = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "questionmark.circle")
                                Text("Где взять файл из SideStore / LiveContainer?")
                            }
                            .font(.footnote)
                            .foregroundStyle(Color.accentColor)
                        }
                        .buttonStyle(.plain)
                    }

                    if !vm.documentsPlistFiles.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Найдено в документах:")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)

                            ForEach(vm.documentsPlistFiles, id: \.self) { filename in
                                HStack {
                                    Image(systemName: "doc.text.fill")
                                        .foregroundStyle(Color.accentColor)
                                    Text(filename)
                                        .font(.caption.monospaced())
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                    Spacer()
                                    Button("Выбрать") {
                                        vm.selectPairingFile(filename: filename)
                                    }
                                    .buttonStyle(.bordered)
                                    .controlSize(.small)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                // On-Device Pairing Section (iOS 27+)
                if isIOS27OrNewer {
                    Section("Сопряжение на этом iPhone") {
                        if vm.pairingPhase == .pairing {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    ProgressView().scaleEffect(0.85)
                                    Text(vm.pairingStatus.isEmpty ? "Запуск локального хоста…" : vm.pairingStatus)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                if let pin = vm.pairingPIN {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("ВВЕДИТЕ ЭТОТ PIN НА IPHONE:")
                                            .font(.caption2.bold().uppercaseSmallCaps())
                                            .foregroundStyle(.secondary)

                                        HStack {
                                            Text(pin)
                                                .font(.system(size: 40, weight: .black, design: .monospaced))
                                                .foregroundStyle(.orange)
                                            Spacer()
                                            Button {
                                                UIPasteboard.general.string = pin
                                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                            } label: {
                                                Label("Копировать", systemImage: "doc.on.doc")
                                                    .font(.caption.bold())
                                            }
                                            .buttonStyle(.bordered)
                                            .tint(.orange)
                                        }

                                        Button {
                                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                                UIApplication.shared.open(url)
                                            }
                                        } label: {
                                            Label("Открыть Настройки iOS", systemImage: "arrow.up.forward.app")
                                                .bold()
                                                .frame(maxWidth: .infinity)
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .tint(.orange)
                                    }
                                    .padding(14)
                                    .background(Color.orange.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                }

                                Button(role: .cancel) {
                                    vm.cancelPairing()
                                } label: {
                                    Text("Отменить")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                }
                                .buttonStyle(.bordered)
                                .tint(.red)
                            }
                        } else {
                            Button {
                                vm.startPairing()
                            } label: {
                                HStack(spacing: 8) {
                                    Spacer()
                                    Image(systemName: "antenna.radiowaves.left.and.right")
                                    Text(vm.hasPairingFile ? "Переподключить iPhone" : "Подключить этот iPhone")
                                        .font(.headline)
                                    Spacer()
                                }
                                .frame(height: 48)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }

                if !vm.log.isEmpty {
                    Section {
                        CompactLogView(
                            title: "Лог событий (\(vm.log.count))",
                            lines: vm.log,
                            onClear: { vm.log.removeAll() }
                        )
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 60)
            }
            .navigationTitle("Подключение")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCredits = true
                    } label: {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.pink)
                    }
                }
            }
            .sheet(isPresented: $showCredits) { CreditsSheet() }
            .sheet(isPresented: $showFilePicker) {
                DocumentPickerView(allowedContentTypes: [
                    UTType(filenameExtension: "mobiledevicepairing") ?? .data,
                    UTType(filenameExtension: "plist") ?? .propertyList,
                    UTType(filenameExtension: "mobilepair") ?? .data,
                    .propertyList, .data, .item
                ]) { url in
                    _ = vm.importPairingFile(from: url, originalName: url.lastPathComponent)
                }
            }
            .sheet(isPresented: $showPairingGuide) {
                PairingGuideSheet {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showFilePicker = true
                    }
                }
            }
            .onAppear {
                vm.refreshNetworkStatus()
                vm.refreshPairingFile()
            }
            .refreshable {
                vm.refreshNetworkStatus()
                vm.refreshPairingFile()
            }
        }
    }
}

// MARK: - VPN Status Row

struct VPNStatusRow: View {
    @ObservedObject var vm: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: vm.vpnUp ? "checkmark.shield.fill" : "exclamationmark.triangle.fill")
                    .font(.title3)
                    .foregroundStyle(vm.vpnUp ? .green : .orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.vpnUp ? "Loopback VPN активен" : "Loopback VPN не обнаружен")
                        .font(.subheadline.bold())
                    Text(vm.vpnUp
                         ? "Туннель готов к работе."
                         : "Включите LocalDevVPN перед прошивкой тем.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if !vm.vpnUp {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Инструкция LocalDevVPN:")
                        .font(.caption.bold())
                    Text("1. Откройте приложение LocalDevVPN и нажмите Connect.\n2. Вернитесь сюда — индикатор станет зелёным.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Link("Открыть LocalDevVPN", destination: URL(string: "localdevvpn://")!)
                        .font(.caption.bold())
                }
                .padding(10)
                .background(Color.orange.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            HStack(spacing: 8) {
                Text("IP устройства:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextField("10.7.0.1", text: $vm.deviceIP)
                    .font(.caption.monospaced())
                    .keyboardType(.decimalPad)
                    .autocorrectionDisabled()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(uiColor: .tertiarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: 120)
                Spacer()
                Button {
                    vm.refreshNetworkStatus()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption.bold())
                }
                .buttonStyle(.bordered)
                .controlSize(.mini)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Passcode Theme Tab

struct PasscodeThemeTab: View {
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Mode", selection: $vm.passcodeMode) {
                        ForEach(CreatorMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                if vm.passcodeMode == .applyTheme {
                    ApplyThemeSection()
                } else {
                    ThemeCreatorSection()
                }

                if !vm.passthmFlashLog.isEmpty {
                    Section {
                        CompactLogView(
                            title: "Flash Log (\(vm.passthmFlashLog.count) lines)",
                            lines: vm.passthmFlashLog,
                            onClear: { vm.passthmFlashLog.removeAll() }
                        )
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 60)
            }
            .navigationTitle("Экран блокировки")
            .onAppear { vm.scanDocumentsDirectory() }
        }
    }
}

// MARK: Apply Theme Section

struct ApplyThemeSection: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var showDocumentPicker = false

    var body: some View {
        if !vm.documentsThemes.isEmpty {
            Section("Темы в папке приложения") {
                ForEach(vm.documentsThemes, id: \.self) { file in
                    HStack {
                        Image(systemName: "paintpalette.fill")
                            .foregroundStyle(Color.accentColor)
                        Text(file)
                            .font(.system(size: 13, design: .monospaced))
                        Spacer()
                        Button("Загрузить") {
                            vm.loadPassthmFromDocuments(filename: file)
                        }
                        .font(.caption.bold())
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                    }
                }
            }
        }

        Section("Выбор файла темы") {
            HStack {
                Button {
                    showDocumentPicker = true
                } label: {
                    Label(vm.loadedTheme == nil ? "Выбрать .passthm из Файлов…" : "Изменить .passthm…",
                          systemImage: "doc.badge.plus")
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                if vm.loadedTheme != nil {
                    Button("Очистить") {
                        vm.clearLoadedTheme()
                    }
                    .font(.caption.bold())
                    .foregroundStyle(.red)
                    .buttonStyle(.borderless)
                }
            }
            .sheet(isPresented: $showDocumentPicker) {
                DocumentPickerView(allowedContentTypes: [
                    UTType(filenameExtension: "passthm") ?? .archive,
                    UTType.zip, UTType.archive
                ]) { url in
                    vm.loadPassthm(url: url)
                }
            }
        }

        if let theme = vm.loadedTheme {
            Section("Предпросмотр клавиатуры") {
                KeypadPreviewView(keys: theme.keysPreview)
                    .listRowInsets(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                    .listRowBackground(Color.clear)
            }

            Section("Информация о теме") {
                LabeledContent("Файлов в теме", value: "\(theme.fileCount)")
                LabeledContent("Кнопок оформлено", value: "\(theme.keysPreview.count)")

                Button {
                    vm.adoptThemeIntoCreator()
                } label: {
                    Label("Редактировать в конструкторе", systemImage: "pencil")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(.bordered)
            }

            PasscodeTargetSection()

            Section {
                VStack(spacing: 12) {
                    flashButton

                    Button(role: .destructive) {
                        vm.clearLoadedTheme()
                    } label: {
                        HStack(spacing: 8) {
                            Spacer()
                            Image(systemName: "trash")
                            Text("Выгрузить тему")
                            Spacer()
                        }
                        .font(.headline)
                        .frame(height: 48)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
                .listRowInsets(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
            }
        }
    }

    @ViewBuilder
    private var flashButton: some View {
        if case .running = vm.passthmFlashPhase {
            HStack(spacing: 10) {
                ProgressView()
                VStack(alignment: .leading, spacing: 4) {
                    Text("Установка темы…").font(.subheadline.bold())
                    ProgressView(value: vm.passthmFlashProgress)
                }
            }
            .padding(.vertical, 4)
        } else {
            Button {
                vm.flashPassthm()
            } label: {
                HStack(spacing: 8) {
                    Spacer()
                    Image(systemName: "bolt.fill")
                    Text("Установить тему на iPhone")
                    Spacer()
                }
                .font(.headline)
                .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!vm.canFlashPassthm)
        }
    }
}

// MARK: - Passcode Target Section

struct PasscodeTargetSection: View {
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        Section("Параметры прошивки") {
            Picker("Версия iOS", selection: $vm.targetTelephonyVersion) {
                Text("TelephonyUI-10 (iOS 18+)").tag("TelephonyUI-10")
                Text("TelephonyUI-9 (iOS 16–17)").tag("TelephonyUI-9")
                Text("TelephonyUI-8 (iOS 14–15)").tag("TelephonyUI-8")
                Text("Универсальный (Все)").tag("all")
            }

            Picker("Язык системы", selection: $vm.passcodeLanguageTarget) {
                ForEach(PasscodeLanguageTarget.allCases) { item in
                    Text(item.rawValue).tag(item)
                }
            }

            Picker("Стиль шрифта", selection: $vm.passcodeBoldTarget) {
                ForEach(PasscodeBoldTarget.allCases) { item in
                    Text(item.rawValue).tag(item)
                }
            }
        }
    }
}

// MARK: Theme Creator Section

struct ThemeCreatorSection: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var selectedDigitForPicker: String? = nil
    @State private var showKeySourceDialog: Bool = false
    @State private var isKeyPhotosPickerPresented: Bool = false
    @State private var isKeyDocumentPickerPresented: Bool = false
    @State private var selectedKey: [PhotosPickerItem] = []

    @State private var showPosterSourceDialog: Bool = false
    @State private var isPosterPhotosPickerPresented: Bool = false
    @State private var isPosterDocumentPickerPresented: Bool = false
    @State private var selectedPoster: [PhotosPickerItem] = []

    var body: some View {
        Section("Режим нарезки") {
            Picker("", selection: $vm.sliceMode) {
                ForEach(SliceMode.allCases) { m in
                    Text(m.rawValue).tag(m)
                }
            }
            .pickerStyle(.segmented)
        }

        if vm.sliceMode == .posterSlice {
            posterSliceSection
        } else {
            individualKeysSection
        }

        Section("Предпросмотр клавиатуры") {
            KeypadPreviewView(keys: vm.effectiveKeys)
                .listRowInsets(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                .listRowBackground(Color.clear)
        }

        PasscodeTargetSection()

        Section {
            VStack(spacing: 12) {
                Button {
                    vm.flashPassthm()
                } label: {
                    HStack(spacing: 8) {
                        Spacer()
                        Image(systemName: "bolt.fill")
                        Text("Установить тему на iPhone")
                        Spacer()
                    }
                    .font(.headline)
                    .frame(height: 50)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!vm.canFlashPassthm)

                if !vm.effectiveKeys.isEmpty {
                    Button {
                        _ = vm.exportPassthm()
                    } label: {
                        HStack(spacing: 8) {
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                            Text("Экспортировать .passthm")
                            Spacer()
                        }
                        .font(.headline)
                        .frame(height: 48)
                    }
                    .buttonStyle(.bordered)

                    Button(role: .destructive) {
                        vm.clearAllCreator()
                    } label: {
                        HStack(spacing: 8) {
                            Spacer()
                            Image(systemName: "trash")
                            Text("Очистить всё")
                            Spacer()
                        }
                        .font(.headline)
                        .frame(height: 48)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }
            .listRowInsets(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
        }
    }

    private var posterSliceSection: some View {
        Group {
            Section("Картинка для клавиатуры") {
                Button {
                    showPosterSourceDialog = true
                } label: {
                    Label(vm.posterImage == nil ? "Выбрать фото…" : "Заменить фото…",
                          systemImage: "photo")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .confirmationDialog("Источник изображения", isPresented: $showPosterSourceDialog, titleVisibility: .visible) {
                Button("Фотоплёнка") { isPosterPhotosPickerPresented = true }
                Button("Выбрать из Файлов…") { isPosterDocumentPickerPresented = true }
                Button("Отмена", role: .cancel) {}
            }
            .photosPicker(isPresented: $isPosterPhotosPickerPresented, selection: $selectedPoster, maxSelectionCount: 1, matching: .images)
            .onChange(of: selectedPoster) { _, items in
                guard let item = items.first else { return }
                Task {
                    if let image = await item.loadUIImage(maxDimension: 2560) {
                        await MainActor.run { vm.setPosterImage(image) }
                    }
                    await MainActor.run { selectedPoster = [] }
                }
            }
            .sheet(isPresented: $isPosterDocumentPickerPresented) {
                DocumentPickerView(allowedContentTypes: [.image, .png, .jpeg, .heic]) { url in
                    if let data = try? Data(contentsOf: url),
                       let image = ImageEngine.safeImageFromData(data, maxDimension: 2560) {
                        vm.setPosterImage(image)
                    }
                }
            }

            if vm.posterImage != nil {
                Section("Стиль нарезки") {
                    Picker("", selection: $vm.maskToCircles) {
                        Text("Единый постер").tag(false)
                        Text("Круглые кнопки").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: vm.maskToCircles) { _, _ in vm.updatePosterSlicing() }
                }

                Section("Масштаб и позиция") {
                    HStack {
                        Text("Масштаб")
                        Spacer()
                        Button("Сбросить") {
                            withAnimation(.spring()) { vm.resetPosterPosition() }
                        }
                        .font(.caption)
                    }
                    Slider(value: $vm.posterZoom, in: 0.5...3.0, step: 0.05)
                        .onChange(of: vm.posterZoom) { _, _ in vm.updatePosterSlicing() }
                }
            }
        }
    }

    private var individualKeysSection: some View {
        Section("Отдельные кнопки") {
            ForEach(KeypadLayout.allButtons) { btn in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(uiColor: .secondarySystemBackground))
                            .frame(width: 44, height: 44)
                        if let img = vm.customKeys[btn.digit] {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                        } else {
                            Text(btn.digit).font(.title3.bold())
                        }
                    }

                    Text("Кнопка \(btn.digit)").font(.subheadline.weight(.medium))
                    Spacer()

                    if vm.customKeys[btn.digit] != nil {
                        Button(role: .destructive) {
                            vm.clearIndividualKey(digit: btn.digit)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.borderless)
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedDigitForPicker = btn.digit
                    showKeySourceDialog = true
                }
            }
        }
        .confirmationDialog("Изображение для кнопки \(selectedDigitForPicker ?? "")", isPresented: $showKeySourceDialog, titleVisibility: .visible) {
            Button("Фотоплёнка") { isKeyPhotosPickerPresented = true }
            Button("Выбрать из Файлов…") { isKeyDocumentPickerPresented = true }
            Button("Отмена", role: .cancel) { selectedDigitForPicker = nil }
        }
        .photosPicker(isPresented: $isKeyPhotosPickerPresented, selection: $selectedKey, maxSelectionCount: 1, matching: .images)
        .onChange(of: selectedKey) { _, items in
            guard let item = items.first, let digit = selectedDigitForPicker else { return }
            let currentDigit = digit
            Task {
                if let image = await item.loadUIImage(maxDimension: 1024) {
                    await MainActor.run { vm.setIndividualKey(digit: currentDigit, image: image) }
                }
                await MainActor.run {
                    selectedKey = []
                    selectedDigitForPicker = nil
                }
            }
        }
        .sheet(isPresented: $isKeyDocumentPickerPresented) {
            DocumentPickerView(allowedContentTypes: [.image, .png, .jpeg, .heic]) { url in
                guard let digit = selectedDigitForPicker else { return }
                if let data = try? Data(contentsOf: url),
                   let image = ImageEngine.safeImageFromData(data, maxDimension: 1024) {
                    vm.setIndividualKey(digit: digit, image: image)
                }
                selectedDigitForPicker = nil
            }
        }
    }
}

// MARK: - Keypad Preview

struct KeypadPreviewView: View {
    @EnvironmentObject var vm: AppViewModel
    let keys: [String: UIImage]

    @State private var dragOffsetStart: CGPoint = .zero
    @State private var isDragging: Bool = false

    private func scaledPosterDimensions(for poster: UIImage, gridW: CGFloat, gridH: CGFloat) -> (width: CGFloat, height: CGFloat) {
        let imgW = poster.size.width
        let imgH = poster.size.height
        guard imgW > 0, imgH > 0 else { return (gridW, gridH) }

        let imgAspect = imgW / imgH
        let gridAspect = gridW / gridH

        if imgAspect > gridAspect {
            let h = gridH * vm.posterZoom
            return (width: h * imgAspect, height: h)
        } else {
            let w = gridW * vm.posterZoom
            return (width: w, height: w / imgAspect)
        }
    }

    var body: some View {
        let scale: CGFloat = 0.68
        let btnD: CGFloat = KeypadLayout.buttonDiameter * scale
        let colW: CGFloat = KeypadLayout.colWidth * scale
        let rowH: CGFloat = KeypadLayout.rowHeight * scale
        let gridW: CGFloat = KeypadLayout.gridWidth * scale
        let gridH: CGFloat = KeypadLayout.gridHeight * scale

        let isSeamlessPoster = (vm.passcodeMode == .themeCreator && vm.sliceMode == .posterSlice && !vm.maskToCircles && vm.posterImage != nil)

        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.07, green: 0.07, blue: 0.09))

            VStack(spacing: 12) {
                ZStack {
                    if isSeamlessPoster, let poster = vm.posterImage {
                        let dims = scaledPosterDimensions(for: poster, gridW: gridW, gridH: gridH)
                        Image(uiImage: poster)
                            .resizable()
                            .frame(width: dims.width, height: dims.height)
                            .position(
                                x: gridW / 2.0 + (vm.posterOffset.x * scale),
                                y: gridH / 2.0 + (vm.posterOffset.y * scale)
                            )
                    }

                    ForEach(KeypadLayout.allButtons) { btn in
                        let cx = CGFloat(btn.col) * colW + colW / 2
                        let cy = CGFloat(btn.row) * rowH + rowH / 2

                        keypadButton(btn: btn, btnD: btnD, scale: scale, isSeamlessPoster: isSeamlessPoster)
                            .position(x: cx, y: cy)
                    }
                }
                .frame(width: gridW, height: gridH)
                .clipped()
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 1)
                        .onChanged { value in
                            if vm.passcodeMode == .themeCreator && vm.sliceMode == .posterSlice && vm.posterImage != nil {
                                if !isDragging {
                                    isDragging = true
                                    dragOffsetStart = vm.posterOffset
                                }
                                vm.posterOffset = CGPoint(
                                    x: dragOffsetStart.x + value.translation.width / scale,
                                    y: dragOffsetStart.y + value.translation.height / scale
                                )
                                vm.updatePosterSlicing()
                            }
                        }
                        .onEnded { _ in
                            isDragging = false
                            dragOffsetStart = vm.posterOffset
                        }
                )
            }
            .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 295)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    @ViewBuilder
    private func keypadButton(btn: KeypadButtonGeometry, btnD: CGFloat, scale: CGFloat, isSeamlessPoster: Bool) -> some View {
        ZStack {
            if isSeamlessPoster {
                Circle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: btnD, height: btnD)
                Circle()
                    .stroke(Color.white.opacity(0.35), lineWidth: 1.0)
                    .frame(width: btnD, height: btnD)
                VStack(spacing: 0) {
                    Text(btn.digit)
                        .font(.system(size: 26 * scale, weight: .light))
                        .foregroundStyle(.white.opacity(0.95))
                    if !btn.letters.isEmpty {
                        Text(btn.letters)
                            .font(.system(size: 8.5 * scale, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
            } else if let img = keys[btn.digit] {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: btnD, height: btnD)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.white.opacity(0.14))
                    .frame(width: btnD, height: btnD)
                VStack(spacing: 0) {
                    Text(btn.digit)
                        .font(.system(size: 26 * scale, weight: .light))
                        .foregroundStyle(.white)
                    if !btn.letters.isEmpty {
                        Text(btn.letters)
                            .font(.system(size: 8.5 * scale, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
            }
        }
        .frame(width: btnD, height: btnD)
    }
}
