
Proje Rehberi – Ne, Nerede, Neden?

Bu proje; basit bir kimlik doğrulama akışı (login + token yönetimi) ve farklı uç noktalara ağ istekleri atan bir yapı içerir. Amacı, hem klasik GCD yaklaşımı hem de modern Swift Concurrency (async/await) ile ağ işlemlerini göstermek ve auth gerektiren/gerektirmeyen endpoint’leri ayırt ederek token kullanımını örneklemektir.

1) Ağ Katmanı (Networking)

1.1 APIClient.swift – Genel İstek Yürütücüsü
- Ne yapar?
  - Verilen Endpoint’e göre URLRequest oluşturur.
  - Endpoint requiresAuth ise Authorization: Bearer <token> header’ını ekler.
  - URLSession üzerinden isteği async/await ile gönderir.
  - Gelen JSON’u Decodable modele çevirir.

- Nasıl çalışır?
  - request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    - endpoint.url yoksa APIError.invalidURL fırlatır.
    - endpoint.requiresAuth true ise TokenStore.shared.token alınır ve header’a eklenir.
    - let (data, _) = try await URLSession.shared.data(for: request) ile istek atılır.
    - JSONDecoder().decode(T.self, from: data) ile decode edilir; hata olursa APIError.decoding fırlatılır.

- Neden bu yapı?
  - Tek bir yerden ağ isteklerini yönetmek, tekrar eden kodu azaltmak ve test edilebilirliği artırmak için.
  - Authorization gibi çapraz kesen endişeleri (cross-cutting concerns) merkezi bir noktadan eklemek için.

1.2 Endpoint.swift – Uç Nokta Tanımları
- Ne yapar?
  - Her API çağrısını tip güvenli bir enum ile temsil eder; URL ve auth gereksinimini belirler.

- İçerik:
  - cases: products, profile
  - url:
    - products -> https://dummyjson.com/products
    - profile -> https://dummyjson.com/auth/me
  - requiresAuth:
    - profile -> true (Authorization gerekir)
    - products -> false (gerekmez)

- Neden bu tasarım?
  - Uç noktaları tek yerden, okunabilir ve genişletilebilir biçimde yönetmek için.
  - Yeni endpoint eklemek kolaydır (case ekle, URL ve requiresAuth tanımla).

1.3 APIError.swift – Hata Tipleri
- Ne yapar?
  - Ortak ağ/decode hatalarını standart bir enum ile temsil eder.

- Durumlar:
  - invalidURL: Endpoint’in URL’i oluşturulamazsa.
  - decoding: JSON decode başarısız olursa.
  - network(Error): Genel ağ hatalarını sarmalamak için (şu an APIClient içinde özel olarak kullanılmıyor, genişletmeye açık).

- Neden?
  - Hata yönetimini merkezileştirmek ve çağıran katmanların anlamlı şekilde tepki verebilmesini sağlamak için.

2) Kimlik Doğrulama (Auth) ve Token Yönetimi

2.1 TokenStore (AuthManager.swift içinde)
- Ne yapar?
  - Uygulama genelinde erişilebilen bir token’ı saklar.

- Kullanım:
  - TokenStore.shared.token üzerinden okunur/yazılır.
  - APIClient, endpoint.requiresAuth true ise bu token’ı Authorization: Bearer <token> olarak header’a ekler.

- Not:
  - Aynı dosyada AuthManager adında ikinci bir singleton da var (o da token tutuyor). Projede aktif kullanılan TokenStore. Temizlik için tek bir yapı etrafında birleşmek (ör. sadece TokenStore) daha iyi olur.

- Güvenlik:
  - Şu an token bellek içinde tutuluyor; uygulama kapanınca kaybolur.
  - Üretim senaryosunda Keychain ile kalıcı ve güvenli saklama önerilir.

3) Giriş (Login) Akışı

3.1 LoginViewModel.swift – Klasik GCD ile Login
- Ne yapar?
  - email ve password ile login isteği atar, isLoading ve errorMessage gibi UI’nın izleyebileceği durumları yönetir.

- Akış:
  - login(completion:)
    - isLoading = true olarak başlar.
    - https://reqres.in/api/login adresine POST atar.
    - Body: { "email": ..., "password": ... } JSON olarak gönderilir.
    - URLSession.shared.dataTask ile istek başlatılır.
    - İstek tamamlanınca DispatchQueue.main ile ana threade dönülür, isLoading = false yapılır ve completion(data != nil) çağrılır.

- Neden GCD?
  - Klasik yaklaşımı göstermek için. Projede hem klasik hem modern concurrency örneği mevcut.

- İyileştirme Önerileri:
  - Bu akışı async/await ile modern hale getirmek (URLSession.shared.data(for:)).
  - Başarılı login sonrası dönen token’ı parse edip TokenStore.shared.token’a atamak; böylece profile gibi requiresAuth endpoint’ler çalışabilir.
  - errorMessage alanını gerçek hatalarla doldurmak ve UI’da göstermek.

4) Uçtan Uca Kullanım Senaryoları

4.1 Ürün Listesi (products)
- Endpoint.products requiresAuth = false.
- APIClient.request ile istek atılır, gelen JSON Decodable modele çevrilir ve UI güncellenir.
- Token’a ihtiyaç yoktur.

4.2 Profil (profile)
- Endpoint.profile requiresAuth = true.
- TokenStore.shared.token yoksa istek 401 ile dönebilir.
- Doğru akış: Login -> token al -> TokenStore.shared.token’a yaz -> profile isteği artık Authorization ile gider.

5) Concurrency Modelleri – Kısa Karşılaştırma

5.1 Klasik (GCD)
- Örnek: LoginViewModel.login içinde dataTask + DispatchQueue.main.
- Özellikler:
  - Thread yönetimi geliştiriciye aittir.
  - UI güncellemeleri için manuel main thread’e dönüş gerekir.
  - Kod karmaşıklığı ve hata riski göreceli olarak yüksektir.

5.2 Modern (Swift Concurrency – async/await)
- Örnek: APIClient.request içinde URLSession.shared.data(for:).
- Özellikler:
  - await thread’i bloklamaz.
  - Kod daha okunabilir ve güvenlidir.
  - SwiftUI’da .task ile başlatılan işler view lifecycle’a bağlı iptal edilebilir.
  - Uzun süren işlerde Task.checkCancellation() kullanmak iptal farkındalığı sağlar.

- Öneri:
  - Proje genelinde tek yaklaşım kullanmak (tercihen async/await) tutarlılığı ve bakım kolaylığını artırır.
  - Login akışını da async/await’e taşımak iyi bir adım olur.

6) Hata Yönetimi ve İyileştirme Alanları

- APIClient:
  - Şu an decoding hatalarını APIError.decoding ile kapsıyor.
  - Ağ hatalarını yakalayıp APIError.network(Error) içine sarmak, üst katmanlarda daha iyi ayrıştırma sağlar.
  - JSONDecoder konfigürasyonu (dateDecodingStrategy, keyDecodingStrategy) gerekirse merkezi olarak burada yapılabilir.

- LoginViewModel:
  - errorMessage doldurulmuyor; gerçek hataları kullanıcıya gösterecek şekilde güncellemek iyi olur.
  - Başarılı yanıtı parse edip token’ı TokenStore’a yazmak önemli (requiresAuth endpoint’leri için).

- Token Saklama:
  - Keychain entegrasyonu ile kalıcı ve güvenli saklama önerilir.

7) Özet

- Endpoint: API uç noktalarını ve auth gereksinimini belirler.
- APIClient: Endpoint’e göre URLRequest hazırlar, token gerekiyorsa Authorization ekler, async/await ile çağırır, Decodable modele çevirir.
- APIError: Hataları standartlaştırır (invalidURL, decoding, network).
- TokenStore: Token’ı uygulama genelinde paylaşır (şimdilik bellek içi).
- LoginViewModel: Login işlemini yönetir; şu an klasik GCD ile örneklenmiştir.
- Modernizasyon: Login’i async/await’e taşı, token’ı TokenStore’a yaz, APIError.network kullanımını genişlet, iptal farkındalığı (Task.checkCancellation) kritik akışlara ekle.
