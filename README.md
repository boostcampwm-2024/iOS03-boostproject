# SniffMEET

<img src="https://github.com/user-attachments/assets/4e3bd3bb-17d7-4cee-bc41-3d5f97967691" width = 200 >

</br>
</br>

> SniffMEET은 반려견에게 친구를 만들어 주고 싶다는 작은 바램에서 시작했습니다.

</br>
</br>

## **👩🏻‍💻🧑🏻‍💻** 팀원 소개

| <img src="https://github.com/pearhyunjin.png"> | <img src="https://github.com/green-yoon87.png"> | <img src="https://github.com/kelly-chui.png"> | <img src="https://github.com/soletree.png"> |
| --- | --- | --- | --- |
| [배현진](https://github.com/pearhyunjin) | [윤지성](https://github.com/green-yoon87) | [최진원](https://github.com/kelly-chui) | [허혜민](https://github.com/soletree) |

</br>
</br>

## **🎯** 프로젝트 목표

- **반려견 성향에 맞춰 산책 친구를 맺을 수 있는 서비스를 제공하자.**
    
    🐾  사람이 아닌 반려동물의 입장에서 친구를 구하고 싶어요
    
    🐾  현재 산책하고 있는 중에 빠르게 산책 친구를 구하고 싶어요
    
    🐾  비슷한 산책 성향을 가진 반려동물 친구를 구하고 싶어요
    

</br>
</br>

## **🐶** 'SniffMEET'에서 가능한 것

### 익명 로그인

- 반려동물 정보 입력만으로 앱 이용이 가능해요
- 반려동물 정보는 홈 프로필 카드를 통해 확인 / 수정할 수 있어요

<img src="https://github.com/user-attachments/assets/67aedbf5-9bce-4be9-891e-667a2f5b0d0d" width = 200 >
<img src="https://github.com/user-attachments/assets/63888b64-b65b-410f-a73e-59aeddc04154" width = 200 >
<img src="https://github.com/user-attachments/assets/f55fd88a-0e49-4843-b579-9df23e3e59c3" width = 200 >

</br>

### 메이트 맺기

- 네임드랍 형태의 기능을 통해 즉석에서 메이트 맺기를 요청할 수 있어요
- 요청이 들어오면 어떤 반려동물인지 정보를 확인할 수 있어요
- 수락시 메이트 관계가 형성되어 이후 함께 산책할 수 있어요
- 거절도 가능해요

<img src="https://github.com/user-attachments/assets/67aedbf5-9bce-4be9-891e-667a2f5b0d0d" width = 200 >
<img src="https://github.com/user-attachments/assets/458bb507-f388-4471-8717-a06bb668fde0" width = 200 >
<img src="https://github.com/user-attachments/assets/9a3f7743-73ee-4f9e-8cca-e5b01b544cca" width = 200 >

</br>

### 산책 요청

- 내 메이트들에게 산책을 요청할 수 있어요
- 간단한 메세지와 만남의 장소를 정해 요청할 수 있어요
- 지도에서 만날 장소를 지정할 수 있어요
- 알림을 통해 메이트에게 요청이 전달돼요

<img src="https://github.com/user-attachments/assets/3141a843-74ce-4647-af41-7ec8b15030f4" width = 200 >
<img src="https://github.com/user-attachments/assets/41eeb613-1266-4b8f-9ef1-13aa99828da0" width = 200 >
<img src="https://github.com/user-attachments/assets/36eeb0d8-187f-4054-a1ce-fc0252c587f3" width = 200 >
<img src="https://github.com/user-attachments/assets/b18fd8ea-16dd-4d66-b82c-c3d72dda3c79" width = 200 >

</br>

### 📌 이후 추가 예정이에요

- 산책 기록을 남길 수 있어요
- 산책 기록을 모아 리포트를 발행해 드려요
- 이미지 분석을 통해 정확한 산책 기록이 가능해요
- 회원가입을 통한 계정 관리로 더 편리한 사용을 지원해요
- 오프라인 만남이 발생하는 환경이니 신고와 차단 기능으로 메이트를 관리할 수 있어요

</br>
</br>

## **🛠** 기술 스택

### VIPER 패턴

팀원들이 모두 사용해보고 싶었던 패턴이라 고려해보게 되었습니다. </br>
구조가 전부 나눠져 있어 초기 설정이 부담된다는 점이 있지만 좀 더 각각의 역할을 명확하게 나누는 과정을 경험할 수 있습니다. </br>
핵심기능 구현 이후로도 여러 기능들을 추가해볼 생각이기 때문에 역할을 잘 나눠둔다면 이후 추가 구현시 수정의 범위가 줄어든다는 이점도 존재할것으로 보입니다.

### Swift Concurrency

동시성 프로그래밍을 위해서는 Swift Concurrency를 선택했습니다. </br>
코드의 뎁스가 깊어지지 않는다는 점에서 가독성이 우수합니다. </br>
또한 에러 핸들링할 때 GCD는 컴파일 에러가 발생하지 않는다는 점과 비교하면 에러 핸들링도 우수합니다. </br>
네트워크와 DB 처리 과정에서 주로 사용합니다.

### Combine

비동기 이벤트를 처리하기 위해서 first-party 프레임워크인 Combine을 선택했습니다. </br>
데이터 바인딩과 UI 처리 과정에서 주로 사용합니다.

### MapKit

사용성이 편리하다는 점과 지도 커스텀이 비교적 쉬운 MapKit을 선택했습니다.

### Supabase

필요한 익명 Auth, DB 기능을 사용하기 위해 선택했습니다.

### Nearby Interaction

탐색한 기기의 거리와 방향을 파악하기 위해 선택했습니다. </br>
UWB를 지원하는 기기(iPhone 11+)에 제한되어 사용 가능합니다.

### Multipeer Connectivity

Nearby Interaction에서 지원하지 않는 데이터 교환을 위해 선택했습니다. </br>
와이파이나 블루투스를 이용해 기기를 탐색하고 연결해 데이터를 전송할 수 있습니다.
DiscoveryToken과 프로필 카드 정보를 교환하는 역할을 합니다.

</br>
</br>

## **📱** 핵심 기능

### NameDrop 기능
NameDrop 형태의 방식으로 기기간 특정 액션에 대한 반응으로 반려견 프로필 카드를 공유할 수 있는 서비스를 제공합니다. </br>
애플에서 공식으로 제공하는 NameDrop API가 없기 때문에
NearbyInteraction + MultipeerConnectivity 이용하여 직접 비슷한 형태로 구현해보기로 했습니다.
아래는 동작 방식에 대한 플로우입니다.

![Screenshot 2024-11-14 at 1 48 06 AM](https://github.com/user-attachments/assets/0889a8d0-c4b1-4f50-a930-c633ada1140f)

- 기기들은 각각 NISession과 MPCSession은 독립적으로 시작됩니다.
- 각 기기들은 MPCSession을 통해 Advertising / Browsing -> Invite 하고 세션을 연결합니다.
- NISession은 시작되면 자동으로 기기마다 DiscoveryToken을 생성합니다.
- DiscoveryToken을 기기끼리 교환하기 위해서 MPCSession을 이용합니다.
- DiscoveryToken이 정상적으로 교환되면 NISession으로 연결되고 기기의 거리와 방향을 파악할 수 있습니다.
- 이후, 해당하는 거리와 방향에 있는 기기와 MPCSession을 통해 데이터(프로필 카드)를 교환하게 됩니다.

</br>
</br>

## **🛠** 개발 환경

| 항목 | 내용 |
| --- | --- |
| 개발 툴 | Xcode 16+ |
| 타켓 버전 | iOS 15+ |
| 버전 관리 도구 | GitHub |
| 코드 품질 관리 도구 | SwiftLint |
| 의존성 관리 도구 | Swift Package Manager (SPM) |


</br>
</br>

## **📁** 문서

| [팀노션](https://www.notion.so/check-it/SniffMeet-129f6d0576c28022a263f6673925113e?pvs=4)  | [Wiki](https://github.com/boostcampwm-2024/iOS03-SniffMeet/wiki) | [디자인](https://www.figma.com/design/hqvx1sLktjajEBcT0lGhyd/SniffMeet?node-id=0-1&m=dev&t=JhNxpBr3EsmhXR5k-1) | [프로덕트 백로그](https://check-it.notion.site/e2052f2712f04f478190eaad9998ff26?pvs=4) |
|:-:|:-:|:-:|:-:|

</br>
</br>

📆 2024. 10. 28 - 진행 중
