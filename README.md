URLSession과 Alamofire을 이용해서 간단한 앱을 구현하고 비교해보쟈🙌

# 애플리케이션 미리보기 & 깃허브 주소

![](https://velog.velcdn.com/images/simh3077/post/89e7d777-e159-4989-a168-4cbc95d6ba9e/image.gif)

[깃허브 주소: URLSession_Alamofire](https://github.com/Jayfunf/URLSession_Alamofire)

# 🚀 시작하기에 앞서
## 💻 Tech Stack
- Swift
- SwiftUI
- Alamofire
- MVVM
## 📱Device
- M1 MacBook Air
- iOS 15.5 iPhone 13 mini Simulator
## 👀 사용할 API
오늘 구현을 위해 사용할 API는 [RandomuserAPI](https://randomuser.me/)이다.

여기서 우리는 https://randomuser.me/api/?results=50&inc=name,email 이 URL을 사용해본다.
URL을 보면 results의 숫자가 불러올 `랜덤User의 수`이며, 뒤의 `name`, `email`는 불러올 데이터의 타입이다. JSON 형태를 살펴보자.
```json
{
	"results":[
    {
    	"name":
        {
        	"title":"Ms",
            "first":"Deanna",
            "last":"Bryant"
		},
       "email":"deanna.bryant@example.com"
    }]
}
```

이 구조에 유의하여 데이터 파싱에 사용할 구조체를 정의해보자.


# 🛫 프로젝트 시작
## ⚙️ 기본 설정
![](https://velog.velcdn.com/images/simh3077/post/b5a41c5d-11ef-49a1-b72c-02b88818146d/image.png)
원하는 Product Name을 작성하고, Interface는 `SwiftUI`로 한다. 우리는 `SwiftUI`로 애플리케이션을 구현하도록 한다.
프로젝트를 생성한 후 종료한다. 프로젝트를 진행하기 전에 `pod`을 통해 `Alamofire`를 추가하도록 해보자.

자세한 방법은 이전 포스팅인 [Realm으로 간단한 메모장 구현하기](https://velog.io/@simh3077/realm%EC%9C%BC%EB%A1%9C-%EA%B0%84%EB%8B%A8%ED%95%9C-%EB%A9%94%EB%AA%A8%EC%9E%A5-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0)에 설명을 따라하거나 검색을 추천한다.

`pod init` 명령어를 입력했다면, Podfile이 생성될 것이다. 이를 열어주자. 그 후 [Alamofire의 Github](https://github.com/Alamofire/Alamofire)로 들어가보자.

![](https://velog.velcdn.com/images/simh3077/post/4be6fe04-6fe9-43c9-94b1-977b0d8c6076/image.png)

사진에 `Installation` 항목에 들어가면 Podfile에 추가하는 방법이 적혀있을 것이다.

![](https://velog.velcdn.com/images/simh3077/post/793efb23-8de6-4a63-9929-3ac050ab0379/image.png)

자 이 방법을 따라서 Podfile을 수정해보자.

![](https://velog.velcdn.com/images/simh3077/post/4a755664-d3c1-451d-b961-85160d469789/image.png)

이렇게 `pop 'Alamofire'` 를 작성하고 저장해준다. 이렇게 하면 가장 최신버전의 라이브러리가 설치될 것이고, 원하는 버전이 있다면, `pod 'Alamofire', '~>5.2'` 이런 식으로 버전을 명시해주자.

그 후 터미널에서 `pop install`을 해주자. 프로젝트 폴더에 `프로젝트명.xcworkspace` 파일이 추가되었다면 성공한 것이다.

이제 우리는 이 `xcworkspace`를 통해 작업을 진행한다.

### pod을 사용한 라이브러리 추가 3줄 요약
1. 터미널을 통해 생성한 프로젝트로 들어가 `pod init` 명령어를 입력한다.
2. 생성된 Podfile을 열어 `pod 'Alamofire'`를 추가하고 저장한다.
3. 터미널에 `pop install`을 입력한다. `프로젝트명.xcworkspace` 파일이 추가되었다면 성공이다.
## 🎯 URLSession
오늘 게시글의 목적이 개발이 아닌 `URLSession`과 `Alamofire`인 만큼 먼저`URLSession`에 대해서 알아보자.

네카라쿠배의 iOS개발자 입사 과정중 사전 과제 전형이 있는 기업에서 오직 Swift로 애플리케이션을 구현하는 과제를 진행한 후기를 보았다.
결국 Alamofire나 URLImage와 같은 라이브러리는 쓰지 못한다는 것이고, 애플이 제공하는 URLSession을 통해 네트워킹을 구현해야 한다.
### URLSession이란?
iOS앱에서 네트워킹을 하기 위해 애플에서 제공하는 `네트워크 API`이다.
후에 다룰 라이브러리인 Alamofire의 기반이 되는 API로 서바와의 데이터 교류를 위해서는 필수적으로 알아야 한다.
URLSession은 `비동기적`으로 작동한다,

### URLSession의 4가지 Session
URLSession은 4가지 종류의 Session을 지원한다.
[Apple의 Documentation](https://developer.apple.com/documentation/foundation/urlsession)을 살펴보자.
- `Dafault Session`: `Shared Session`과 유사하지만 우리가 직접 구성할 수 있으며, 데이터를 점진적(data를 점차 증가시키면서)으로 받아올 수 있도록 delegate를 할당할 수 있다. 기본적인 Session으로 디스크 기반 캐싱을 지원한다.
> A default session behaves much like the shared session, but lets you configure it. You can also assign a delegate to the default session to obtain data incrementally.

- `Ephemeral Session`: 한글로 임시 세션으로 `Shared Session`과 비슷하지만 어떠한 데이터도 저장하지 않는다.
> Ephemeral sessions are similar to shared sessions, but don’t write caches, cookies, or credentials to disk.

- `Background Session`: 앱이 백그라운드에 있어도 통신을 진행한다.
> Background sessions let you perform uploads and downloads of content in the background while your app isn’t running.

- `shared Session`: Singleton인 기본 Session이다. 우리가 직접 구성할 수 없기에 요구 사항이 매우 제한적인 경우 사용하기 좋다.
> URLSession has a singleton shared session (which doesn’t have a configuration object) for basic requests. It’s not as customizable as sessions you create, but it serves as a good starting point if you have very limited requirements.

### Default Session과 shared Session의 차이
나중에 코드를 소개할 것이지만 이번에 진행한 간단한 개발에서는 dafault와 shared 모두 사용할 수 있다.

둘의 차이를 보자면,

shared Session은 delegate나 configuration이 없다. 그냥 딸랑 `URLSession.shared`만 사용하면 끝이다. 결국 이로인해 아래와 같은 한계점이 존재한다.

- default는 점진적으로 데이터를 받지만 shared는 그럴 수 없다.
- shared는 authenticaion을 수행하는 기능을 사용할 수 없다.
- background에서 download나 upload를 수행할 수 없다.
...

따라서 상황에 맞는 Session을 골라 통신을 진행해야 한다.

### URLSession의 4가지 Task
- `Data tasks`: NSData 객체를 사용하여 데이터를 주고 받는 task이다. 주로 짧고 빈번한 통신에 사용한다.
> Data tasks send and receive data using NSData objects. Data tasks are intended for short, often interactive requests to a server.

- `Upload tasks`: 데이터를 업로드하고(종종 파일 형식), 앱이 실행되지 않는 동안 백그라운드 업로드를 지원한다.
> Upload tasks are similar to data tasks, but they also send data (often in the form of a file), and support background uploads while the app isn’t running.

- `Download tasks`: 파일 형식으로 데이터를 검색하고 앱이 실행되지 않는 동안 백그라운드 다운로드 및 업로드를 지원한다.
> Download tasks retrieve data in the form of a file, and support background downloads and uploads while the app isn’t running.

- `WebSocket`: 웹소켓 작업은 RFC 6455에 정의된 WebSocket 프로토콜을 사용하여 TCP, TLS를 통해 메시지를 교환한다.
> WebSocket tasks exchange messages over TCP and TLS, using the WebSocket protocol defined in RFC 6455.

## 🎯 Alamofire
Alamofire란 비동기로 수행하는 Swift기반의 HTTP 네트워킹 라이브러리이다.
앞서 언급했듯 Alamofire도 결국 URLSession를 기반으로 갖고 있다.
보다 사용하기 쉬우며, 직관적인 사용법을 가지고 있다.

~~URLSession에 비해서 너무 짧다면... 그것은 주인공이 URLSession이기 때문!!~~

# 👨‍💻 완성
## 🏗 구조
역시 SwiftUI라 그런지 나도 모르게 MVVM ~~일 수도 있고 아닐 수도 있는~~ 패턴을 사용했다.

![](https://velog.velcdn.com/images/simh3077/post/eb7dbcb8-4240-42e6-9c74-b137a8b6b559/image.png)

아래서 더 자세히 각 스위프트 파일의 기능과 동작을 간략하게 소개한다.

`URLSession_AlamofireApp`은 iOS14부터인가 15부터인가 `AppDelegate`와 `SceneDelegate`를 대체해서 나온 친구이다. 건드릴 설정이 없기에 소개 ㄴㄴ요.

### 각 파일의 자기소개
- `ContentView`: 저는 메인 화면이에오. Alamofire와 URLSession으로 네트워킹한 결과물을 보여주는 AlamofireView와 SessionView로 NavigationLink를 통해 이동을 하도록 도와요!
- `Model`: 받아올 JSON의 구조를 정의해요. 제가 없으면 파싱할 수 업써요.
- `Networking`: ObservableObject로 제가 @Published를 통해 선언한 것을 다른 곳에서 @ObservedObject을 통해 인스턴스를 만들어 접근할 수 있어요. MVVM의 VM에 해당하는 역할과 urlSessionNetworking(), alamofireNetworking()을 통해 네트워킹도 동시에 진행해서 이를 저장해 @Published를 통해 발급해요.
- `ListView`: 위의 Networking에서 저장한 UserData들을 받은 View들이 저를 통해 깔끔한 리스트로 반환해 받아요. 각 뷰에 선언해도 괜찮지만 재사용을 위해 따라 만들어졌어요. 
- `AlamofireView`: Alamofire를 통해 받은 데이터를 ListView에 전달하고 이를 통해 리스트를 구현해요.
- `SessionView`: URLSession을 통해 받은 데이터를 ListView에 전달하고 이를 통해 리스트를 구현해요.
## 📚 코드 및 설명
### ContentView
```swift
struct ContentView: View {
    let gradient: LinearGradient = {
        let colors: [Color] = [.orange, .pink, .purple, .red, .yellow, .cyan]
            return LinearGradient(gradient: Gradient(colors: [colors.randomElement()!, colors.randomElement()!]), startPoint: .center, endPoint: .topTrailing)
        }()
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
                    .cornerRadius(10)
                Spacer()
                Divider()
                Text("Click Here👇")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .frame(width: 300, alignment: .leading)
                    
                VStack {
                    Button {
                        print("Alamofire Button Clicked")
                    } label: {
                        NavigationLink("Alamofire"){
                            AlamofireView()
                        }
                        .frame(width: 300)
                        .padding()
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        
                    }
                    Button {
                        print("URLSession Button Clicked")
                    } label: {
                        NavigationLink("URLSession"){
                            SessionView()
                        }
                        .frame(width: 300)
                        .padding()
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
            }
            .background(gradient)
        }
    }
}
```
사실 ContentView에서 볼만한건 없다. 그냥 디자인을 위한 Code들이다.
핵심이라고 말할 것은 버튼과 NavigationLink로 각 뷰에 연결해주는 정도.

사실 그냥 버튼 두개 던져놔도 상관없다.
### Model
```swift
struct UserDatas: Codable {
    var results: [RandomUser]
}

struct RandomUser: Codable, Identifiable {
    let id = UUID()
    let name: Name
    let email: String
    
    struct Name: Codable {
        var title: String
        var first: String
        var last: String
        
        var full: String {
            return "\(self.title.capitalized).\(self.last.capitalized) \(self.first.capitalized)"
        }
    }
    
    static func getDummy() -> Self {
        return RandomUser(name: Name.init(title: "MR", first: "Minhyun", last: "Cho"), email: "simh3077@gmail.com")
    }
}
```
앞서 설명했지만 RandomUserAPI로부터 넘어오는 JSON 데이터는 아래와 같은 구조를 갖는다.
```json
{
	"results":[
    {
    	"name":
        {
        	"title":"Ms",
            "first":"Deanna",
            "last":"Bryant"
		},
       "email":"deanna.bryant@example.com"
    }]
}
```
따라서 이를 `파싱하기 위한 구조`를 선언해두는 것이다.

### Networking
```swift
class networkingClass: ObservableObject {
    
    @Published var randomUser = [RandomUser]()
    
    func urlSessionNetworking(url: String) {
        //MARK: URL생성, guard let으로 옵셔널 검사
        guard let sessionUrl = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        //MARK: Default Session을 생성하거나, Shared Session을 생성 | 둘 다 상관X
        //let session = URLSession(configuration: .default)
        let session = URLSession.shared
        
        //MARK: Request 생성, URL은 위에서 생성한 URL을 파라미터로 넘겨줌, 생성한 requestURL의 HTTP메서드 설정
        var requestURL = URLRequest(url: sessionUrl)
        requestURL.httpMethod = "GET"
        
        //MARK: 헤더 설정, requestURL의 헤더에 넣어 헤더 사용
        let header: HTTPHeaders = ["Content-Type":"application/json", "Accept":"application/json"]
        requestURL.headers = header
        
        //MARK: Task 인스턴스 생성, Data Task 사용
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            // 에러검사
            guard error == nil else {
                print(error!)
                return
            }
            
            // data 확인 response의 유효성 검사
            guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            // 데이터를 JSONDecoder()를 통해 UserDatas form으로 data를 디코딩하여 decodedData에 저장
            guard let decodedData = try? JSONDecoder().decode(UserDatas.self, from: data) else {
                print("Error: JSON parsing failed")
                return
            }
            // 디코드한 data값을 해당 클래스의 randomUser에 저장
            self.randomUser = decodedData.results
        }
        // resume()을 불러주어야 한다. Task는 기본적으로 suspended상태로 시작한다. 따라서 이를 호출해서 data task를 시작한다.
        // Task를 실행할 경우 강한 참조를 걸어 Task가 끝나거나 실패할 때까지 유지해준다. 네트워킹이 중간에 끊기지 않도록.
        dataTask.resume()
    }

    func alamofireNetworking(url: String) {
        //MARK: URL생성, guard let으로 옵셔널 검사
        guard let sessionUrl = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        //MARK: Request생성
        AF.request(sessionUrl,
                   method: .get, // HTTP메서드 설정
                   parameters: nil, // 파라미터 설정
                   encoding: URLEncoding.default, // 인코딩 타입 설정
                   headers: ["Content-Type":"application/json", "Accept":"application/json"]) // 헤더 설정
            .validate(statusCode: 200..<300) // 유효성 검사
            //MARK: responseDecodable을 통해 UserDatas form으로 디코딩, response의 성공 여부에 따라 작업 분기
            .responseDecodable (of: UserDatas.self) { response in
                switch response.result {
                case .success(let value):
                    self.randomUser = value.results
                case .failure(let error):
                    print(error)
                }
            }
    }
}
```
`ObservableObject`로 선언하여, `@Published`를 통해 외부에서 이를 관찰하고 사용할 수 있다.
또 이번 포스팅의 핵심인 `URLSession`을 통한 네트워킹과, `Alamofire`를 통한 네트워킹을 지원하는 `두 메서드`가 존재한다.

각 메서드에 주석을 달아두었으니 참고하길 바란다. 

두 메서드의 자세한 비교는 후에 진행한다.
### ListView
```swift
struct ListView: View {
    var prdData: RandomUser
    
    let gradient: LinearGradient = {
        let colors: [Color] = [.orange, .pink, .purple, .red, .yellow, .blue, .cyan]
            return LinearGradient(gradient: Gradient(colors: [colors.randomElement()!, colors.randomElement()!]), startPoint: .center, endPoint: .topTrailing)
        }()
    
    init(_ prdData: RandomUser) {
        self.prdData = prdData
    }
    
    var body: some View {
        HStack {
            Image(systemName: "heart")
                .padding()
                .background(gradient)
                .cornerRadius(10)
            VStack(alignment: .leading){
                Text("\(prdData.name.title). \(prdData.name.first)\(prdData.name.last)")
                Text("\(prdData.email)")
            }
            
        }
    }
}
```
네트워킹을 통해 디코드된 JSON값을 받은(사실 발행한 것을 관찰) 각 뷰는 이를 이쁘게 리스트에 표시하기 위해 이 ListView를 사용한다.

ListView는 받은 RandomUser 타입이 값을 디자인한다. 그럼 각 뷰는 이 리스트의 셀을 가지고 리스트를 구성한다.
### AlamofireView
```swift
struct AlamofireView: View {
    @ObservedObject var networking = networkingClass()
    let url = "https://randomuser.me/api/?results=50&inc=name,email"
    
    init() {
        networking.alamofireNetworking(url: url)
    }
    
    var body: some View {
        List(networking.randomUser) { datas in
            ListView(datas)
        }
    }
}
```
이 뷰가 동작하기 전까지 네트워킹은 진행되지 않는다. 이 뷰가 올라오는 순간 init()을 통해 네트워킹이 이루어지고 이 데이터가 ObservableObject인 networkingClass에 저장되어 이를 AlamofireView가 꺼내서 사용하는 것이다.

이 데이터를 ListView에 보내 디자인하고 이를 리스트로 표현한다.

### SessionView
```swift
struct SessionView: View {
    @ObservedObject var networking = networkingClass()
    let url = "https://randomuser.me/api/?results=50&inc=name,email"
    
    init() {
        networking.urlSessionNetworking(url: url)
    }
    
    var body: some View {
        List(networking.randomUser) { datas in
            ListView(datas)
        }
    }
}
```
이 뷰가 동작하기 전까지 네트워킹은 진행되지 않는다. 이 뷰가 올라오는 순간 init()을 통해 네트워킹이 이루어지고 이 데이터가 ObservableObject인 networkingClass에 저장되어 이를 SessionView가 꺼내서 사용하는 것이다.

이 데이터를 ListView에 보내 디자인하고 이를 리스트로 표현한다.

## 🥸 URLSession과 Alamofire의 비교
두 코드를 주석 없이 다시 보자.
```swift
{
    func urlSessionNetworking(url: String) {
        guard let sessionUrl = URL(string: url) else {
            print("Invalid URL")
            return
        }
        //let session = URLSession(configuration: .default)
        let session = URLSession.shared
        
        var requestURL = URLRequest(url: sessionUrl)
        requestURL.httpMethod = "GET"
        
        let header: HTTPHeaders = ["Content-Type":"application/json", "Accept":"application/json"]
        requestURL.headers = header
        
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
           
            guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }

            guard let decodedData = try? JSONDecoder().decode(UserDatas.self, from: data) else {
                print("Error: JSON parsing failed")
                return
            }
            self.randomUser = decodedData.results
        }
        dataTask.resume()
    }

    func alamofireNetworking(url: String) {
        guard let sessionUrl = URL(string: url) else {
            print("Invalid URL")
            return
        }
        AF.request(sessionUrl,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300) 
            .responseDecodable (of: UserDatas.self) { response in
                switch response.result {
                case .success(let value):
                    self.randomUser = value.results
                case .failure(let error):
                    print(error)
                }
            }
    }
}
```

단순히 보기만 해도 Alamofire쪽이 훨 직관적이고 간단한 것을 확인할 수 있다.

Alamofire의 경우 url, method, parameters. encoding, headers를 모두 한 request안의 파라미터로 받지만, URLSession은 그렇지 못하다.

헤더의 경우도 Authorization을 위해 헤더를 사용하는 경우가 많을 것이다. 나 또한 프로젝트를 진행하며 UserToken을 헤더에 넣어 서버에 날리곤 했다. 이 또한 Alamofire가 훨 직관적인것을 알 수 있다.

# 🛬 정리하며
Alamofire만 사용해본 iOS꼬꼬마 입장에서 매우 큰 공부가 되었다.

만약 Alamofire를 사용하지 못할 경우 URLSession을 통해 네트워킹을 구현해야 할텐데 이를 위한 매우 귀중한 시간이었다.

또 다른 프로젝트를 진행하면 Alamofire와 URLSession 모두 구현하여 두 방식을 조금 더 깊게 공부하고 싶을 따름이다.

# 🤙 References
[[resume()] - Apple Documentation](https://developer.apple.com/documentation/foundation/urlsessiontask/1411121-resume)
[[URLSession] - Apple Documentation](https://developer.apple.com/documentation/foundation/urlsession)
