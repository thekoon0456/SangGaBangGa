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

## 📱시연 영상
|<img src="https://github.com/thekoon0456/SangGaBangGa/assets/106993057/d1e332e9-a6ba-4d88-a74f-f75dd23ad826" width="200"></img>|<img src="https://github.com/thekoon0456/SangGaBangGa/assets/106993057/c11a36a3-f599-483a-b330-567c31efbcd4" width="200"></img>|<img src="https://github.com/thekoon0456/SangGaBangGa/assets/106993057/ab19932f-98b2-4ab9-8a81-59764238c0fa" width="200"></img>|<img src="https://github.com/thekoon0456/SangGaBangGa/assets/106993057/02c6c645-a794-4ba0-ad99-bbed6cfc03f3" width="200"></img>|
|:-:|:-:|:-:|:-:|
|`피드`|`게시글 작성`|`댓글 작성`|`메세지 보내기`|
|<img src="https://github.com/thekoon0456/SangGaBangGa/assets/106993057/00ae5c9b-d201-44fd-9582-0934c6166dfa" width="200"></img>|<img src="https://github.com/thekoon0456/SangGaBangGa/assets/106993057/27a13156-4e65-4c68-ab35-ec230e581204" width="200"></img>|<img src="https://github.com/thekoon0456/SangGaBangGa/assets/106993057/65302b8c-3fb4-4524-b960-ed70e5dafe4c" width="200"></img>|<img src="https://github.com/thekoon0456/SangGaBangGa/assets/106993057/0eed20bd-3544-4cdf-b9ae-24830859dfc4" width="200"></img>|
|`계약금 결제`|`지도 검색`|`지도 매물 이동`|`마이페이지`|
<br>

## 💻 앱 개발 환경

- 최소 지원 버전: iOS 16.0+
- Xcode Version 15.0.0
- iPhone SE3 ~ iPhone 15 Pro Max 전 기종 호환 가능
<br>

## 💡 기술 소개

### Clean Architecture
- MVVM 구조에서 ViewModel이 모든 로직을 처리하는 것을 줄이기 위해 Clean Architecture 적용
- View - ViewModel - UseCase - Repository - DataSource로 레이어 분리
- 서버에서 온 데이터의 모델과 앱 내에서 사용되는 데이터의 모델을 분리하여 서버의 변경에 유연하게 대처
- Repository 패턴을 활용해 DataSource 캡슐화
- 앱의 핵심 로직을 작은 기능의 단위의 UseCase를 나누어 단일 책임 원칙을 준수하도록 구현
- 계층과 모듈의 역할이 명확하게 분리되어 코드 가독성, 재사용성 향상
<br>

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

## ✅ 트러블 슈팅
### 사용자의 편의를 위해 AccessToken 갱신을 통한 자동 로그인 구현
<div markdown="1">
앱을 켤때마다 로그인을 해야하는 번거로움을 해소하기 위해 자동 로그인 기능 도입<br>
Moya의 RequestInterceptor를 통해 RefreshToken의 만료 전까지는 AccessToken을 자동으로 갱신하도록 구현<br>
Coordinator와 errorSubject를 구독해 RefreshToken의 갱신이 만료되면 로그인 화면으로 이동<br>
<br>

```swift
final class TokenInterceptor: RequestInterceptor {
    ...
    static let refreshSubject = BehaviorSubject<Void>(value: ())
    static let errorSubject = PublishSubject<Void>()
    ...

    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse else { return }
        //엑세스 토큰 만료
        guard response.statusCode == 419 else {
            //login화면으로
            if response.statusCode == 418 {
                TokenInterceptor.errorSubject.onNext(())
            }
            completion(.doNotRetryWithError(error))
            return
        }

        //엑세스 토큰 갱신
        UserAPIManager.shared.refreshToken()
            .subscribe { response in
                UserDefaultsManager.shared.userData.accessToken = response.accessToken
                TokenInterceptor.refreshSubject.onNext(())
            }
            .disposed(by: disposeBag)
        completion(.doNotRetry)
    }
}
```
</div>
<br>

### 각 Cell마다 좋아요 버튼과 댓글 버튼을 연동하는 방식 변경. CellViewModel을 생성하는 방식에서 FeedViewModel로 로직 이동
<div markdown="1">
Main Feed의 각 Cell마다 좋아요 버튼이 눌리거나, 댓글 버튼이 눌렸을때 UI변경, 서버통신 등의 역할을 수행<br>
기존에는 Cell에 ViewModel 인스턴스를 생성하는 방식으로 구현했으나, Cell을 화면에 구성할때마다 CellViewModel과 관련 인스턴스들이 생성되어 메모리에 비효율적<br>
메모리를 효율적으로 활용하기 위해 CellViewModel의 로직을 FeedViewModel로 이동하고, 클로저로 외부에서 Action을 주입하는 방식으로 변경<br>
불필요한 인스턴스 생성을 줄이고, 뷰모델에서 일관된 로직 처리 구현<br>
<br>

```swift

// MARK: - MainFeedCell
...
var heartButtonTapped: (() -> Void)?
var commentButtonTapped: (() -> Void)?

 override func prepareForReuse() {
     super.prepareForReuse()
     heartButtonTapped = nil
     commentButtonTapped = nil
 }
...

// MARK: - FeedViewController
...
private func feedCellRegistration() -> UICollectionView.CellRegistration<MainFeedCell, ContentEntity> {
    UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
        cell.configureCellData(itemIdentifier)
        
        cell.heartButtonTapped = { [weak self] in
            guard let self else { return }
            let isSelected = itemIdentifier.likes.contains(UserDefaultsManager.shared.userData.userID ?? "") ? true : false
            cellHeartButtonSubject.onNext((indexPath.item, isSelected))
        }
        
        cell.commentButtonTapped = { [weak self] in
            guard let self else { return }
            cellCommentButtonSubject.onNext(indexPath.item)
        }
    }
}
...

// MARK: - FeedViewModel
...
input
    .cellCommentButtonTapped
    .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
    .asDriver(onErrorJustReturn: 0)
    .drive(with: self) { owner, index in
        let comments = owner.sortedComments(dataRelay.value[index].comments)
        commentsRelay.accept(comments)
        owner.coordinator?.presentComment(data: dataRelay.value[index],
                                          commentsRelay: commentsRelay)
    }
    .disposed(by: disposeBag)
...
```
</div>
<br>

### 매물의 주소를 좌표로 변환해 지도에 표시
<div markdown="1">
매물으 등록할 때 입력한 매물의 주소를 좌표로 변환해 지도에 띄워주기 위해 CLGeocoder 사용<br>
CustomAnnotationView를 구성해 매물의 사진, 정보와 위치를 지도에 바로 표시하도록 구현 <br>
<br>

```swift

// MARK: - MapViewModel
...
input
    .address
    .withUnretained(self)
    .flatMap { owner, value in
        owner.convertAddressToCoordinates(address: value)
            .catchAndReturn("")
    }
    .subscribe { value in
        request.content3 = value
    }
    .disposed(by: disposeBag)
...
func convertAddressToCoordinates(address: String) -> Observable<String> {
    return Observable.create { observer in
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                observer.onError(error)
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                observer.onNext("\(location.coordinate.latitude) / \(location.coordinate.longitude)")
                observer.onCompleted()
            } else {
                let error = SSError.LocationError
                observer.onError(error)
            }
        }
        
        return Disposables.create()
    }
}
```
</div>
<br>
