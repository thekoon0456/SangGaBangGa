# 상가를 찾을때? 상가방가!
상가 전용 부동산 중개 앱입니다. <br>
- 실시간으로 업데이트되는 상가 매물! <br>
- 지도를 통해 내 위치 주변 매물을 한 눈에 볼 수 있습니다. <br>
- 결제 기능을 통해 계약금을 바로 결제하실 수 있습니다. <br>
- 좋아요 누른 글, 내가 작성한 글, 계약금을 결제한 글을 관리하실 수 있습니다. <br>
<br>

## 📱스크린샷
<img src="https://github.com/thekoon0456/SangGaBangGa/assets/106993057/16b60e03-f68c-4d49-b02e-600108fb8b86" width="150"></img>
<img src="https://github.com/thekoon0456/SangGaBangGa/assets/106993057/37fc4767-5bae-423c-a13d-d0e3fff15ddd" width="150"></img>
<img src="https://github.com/thekoon0456/SangGaBangGa/assets/106993057/5f2379c2-ee4e-4f54-b606-667ac9cc2217" width="150"></img>
<img src="https://github.com/thekoon0456/SangGaBangGa/assets/106993057/77c36456-df23-4ac1-a680-c11791703b1e" width="150"></img>
<img src="https://github.com/thekoon0456/SangGaBangGa/assets/106993057/5f6afb0a-405c-4a8d-a06b-601c6a99a2df" width="150"></img>

## 📌 주요 기능
- 이메일 회원가입, 로그인 기능 <br>
- 실시간으로 업데이트되는 게시글 <br>
- 좋아요, 댓글 기능 <br>
- 글 작성자 전화, 문자 기능 <br>
- 지도를 통해 주변 매물 관리와 검색기능 <br>
<br>

## 기술 스택
- UIKit, MVVM-C, Input-Output, Singleton, Repository, CodeBasedUI
- RxSwift, RxMoya, NWPathMonitor, RxGesture ,iamport-ios
- MapKit, CoreLocation, MessageUI
- CompositionalLayout, CollectionViewPagingLayout, DiffableDataSource,
- Kingfisher, SnapKit, IQKeyboardManagerSwift, MarqueeLabel
<br>

## 💻 앱 개발 환경

- 최소 지원 버전: iOS 16.0+
- Xcode Version 15.0.0
- iPhone SE3 ~ iPhone 15 Pro Max 전 기종 호환 가능
<br>

## 💡 기술 소개

### MVVM
- 뷰의 로직과 비즈니스 로직을 분리하고 관리하기 위해 MVVM 아키텍처를 도입
- Input, Output 패턴을 활용해 뷰의 이벤트들을 Input에 바인딩하고, 뷰에 보여질 데이터를 Output에 바인딩
- 데이터의 흐름을 단방향으로 구성하고 뷰모델의 코드 가독성 향상
- ViewModel Protocol을 활용해 구조적화된 뷰모델 구성
<br>

### Coordinator 패턴
- CodeBasedUI로 UI구성, Storyboard에 비해 화면 전환의 흐름을 직관적으로 파악하기 힘든 단점
- 화면 전환 코드가 복잡해지고 비대해지는 문제를 해결하기 위해 뷰 컨트롤러와 화면 전환 로직을 분리해서 관리
- Coordinator 생성, Repository 생성, ViewModel 생성, ViewController 생성하는 패턴으로 의존성 주입
- ViewController의 Input이 ViewModel의 Coordinator로 전달하여 화면 전환
<br>

### RxSwift
- RxSwift를 활용해 앱 내의 일관성 있는 비동기 처리
- 연속된 escaping closure를 피하고, 선언형 프로그래밍을 통한 코드 가독성을 높임
- Traits을 활용해 일관된 Thread 관리
- 데이터가 발생하는 시점에서부터 뷰에 그려지기까지 하나의 스트림으로 데이터 바인딩
<br>

### RxMoya
- 다양한 역할의 API를 Router패턴과 RxSwift를 연동해 관리하기 위해 RxMoya 활용
- UserRouter, PostsRouter, PaymentRouter등 세분화한 역할의 Router를 TargetType을 통해 구현
- API에 필요한 Request, Response 모델을 구성하고 Entity로 변환해 앱 내에서 데이터 활용
- RequestInterceptor를 활용해 Login Token Refresh 관리
<br>

### Repopsitory 패턴
- Repository 패턴을 사용해 데이터 계층 추상화
- DIP를 활용해 Repository의 의존성 역전, 결합성을 낮추고 유지보수성 향상
<br>

### MapKit
- 사용자의 위치 파악을 위해 CLLocation을 기반으로 LocationManager 관리
- CustomAnnotationView를 활용해 지도에 원하는 화면 표시
- CLGeocoder를 활용하여 주소와 좌표 변환해 연동
<br>

### ModernCollectionView
- UICollectionView CompositionalLayout활용해 Layout 구현
- DiffableDataSource활용해 데이터 바인딩
- RxSwift의 modelSelected 메서드와 충돌하는 이슈 발생, itemSelected로 변경
<br>

### iamport를 활용한 결제기능 구현
- 사용자마다 다양한 결제 수단을 한번에 관리하기 위해 iamport 활용
- PaymentsServiceClass를 구현해 결제 관리
<br>

### NWPathMonitor
- 네트워크 모니터링과 네트워크 단절상황 관리
- CustomToast를 활용해 에러처리, 사용자와의 Interaction 제공
<br>
