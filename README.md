# 상가를 찾을때? 상가방가!
상가 전용 부동산 중개 앱입니다. <br>
- 실시간으로 업데이트되는 매물들! <br>
- 지도를 통해 현재 매물을 한 눈에 볼 수 있습니다. <br>
- 결제 기능을 통해 계약금을 바로 결제하실 수 있습니다. <br>
- 좋아요 누른 글, 내가 작성한 글, 계약금을 결제한 글을 관리하실 수 있습니다. <br>
<br>

## 📱스크린샷

## 📌 주요 기능
- 이메일 회원가입, 로그인 기능 <br>
- 실시간으로 업데이트되는 다양한 매물 <br>
- 좋아요, 댓글 기능 <br>
- 전화, 문자 연결 기능 <br>
- 지도를 통해 현재 매물을 한 눈에 볼 수 있습니다. <br>
- 결제 기능을 통해 계약금을 바로 결제하실 수 있습니다. <br>
- 좋아요 누른 글, 내가 작성한 글, 계약금을 결제한 글을 관리하실 수 있습니다. <br>
<br>

## 기술 스택
- UIKit, MVVM-C, Input-Output, Singleton, Repository, CodeBasedUI
- RxSwift, RxMoya, NWPathMonitor, RxGesture ,iamport-ios
- MapKit, CoreLocation, MessageUI
- Compositional Layout, CollectionViewPagingLayout, DiffableDataSource,
- Kingfisher, SnapKit, IQKeyboardManagerSwift, MarqueeLabel
<br>

## 💻 앱 개발 환경

- 최소 지원 버전: iOS 16.0+
- Xcode Version 15.0.0
- iPhone SE3 ~ iPhone 15 Pro Max 전 기종 호환 가능
<br>

## 💡 기술 소개

### MVVM
- 사용자 입력 및 뷰의 로직과 비즈니스에 관련된 로직을 분리하기 위해 MVVM을 도입
- Input, Output 패턴을 활용해 데이터의 흐름을 전달받을 값과, 전달할 값을 명확하게 나누고 관리
- ViewModel Protocol을 활용해 구조적으로 일관된 뷰모델 구성
<br>

### Coordinator 패턴
- 화면 전환 코드가 복잡해지고 비대해지는 문제를 해결하기 위해 뷰 컨트롤러와 화면 전환 로직을 분리
- Coordinator 생성, Repository 생성, ViewModel 생성, ViewController 생성하는 패턴으로 의존성 주입
- ViewController의 Input이 ViewModel의 Coordinator로 전달하여 화면 전환
<br>

### RxSwift
- RxSwift를 활용해 앱 내의 일관성 있는 비동기 처리와 Traits를 활용하여 Thread 관리
<br>

### RxMoya
- 다양한 역할의 API를 Router패턴과 RxSwift를 연동해 관리하기 위해 RxMoya 활용
- UserRouter, PostsRouter, PaymentRouter등 댜앙한 역할의 Router를 TargetType을 활용해 Router 구현
- API에 필요한 Request, Respose 모델을 구성하고 Entity로 변환해 앱 내에서 데이터 활용
- RequestInterceptor를 활용해 Login Token Refresh
<br>

### Repopsitory 패턴
- Repository 패턴을 사용해 데이터 계층 추상화
- DIP를 활용해 의존성 역전, 결합성을 낮추고 유지보수성 향상
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
