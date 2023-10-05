import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(
            apiKey: "bb5f1c41-cfab-4575-a6b3-6f26cb3379cc"
        ) else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
