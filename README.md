# DoNature(도네이처)
<img src="https://github.com/ooing-0720/DoNature/assets/87466004/4c387421-ea28-42d7-ab64-dc3b1655cf0b" width="70%" height="70%"/>

실시간 기후재난 알림, 대처법과 정보 공유 및 나눔 플랫폼(모바일 앱)

## 📜 서비스 내용

실시간으로 전국 및 사용자 위치 기반의 기상 상황과 재난 경보, 대처법을 안내하고, 게시판 및 채팅 기능을 통해 재난 상황을 알리고 도움을 주고 받을 수 있는 앱 입니다.

### 주요 기능
1. **안내** : 공공데이터 API를 통해 실시간 전국 재난 상황 공유 및 대처법 안내
2. **나눔** : 도움이 필요하거나 다른 사람을 돕고 싶은 누구나 이용 가능
3. **게시판** : 재난 상황 정보를 공유하거나 나눔을 주고받을 수 있는 열린 공간
4. **채팅** : 재난 상황과 정보를 공유하거나 나눔을 주고받을 수 있는 일대일 공간

### 목표
- 도네이처를 통해 기상 재난의 심각성을 알리고 거주지가 아닌 다른 지역에서 발생한 재난 상황에의 관심을 높이고 싶습니다.
- 재난 상황 맞춤형 나눔 앱을 통해 여러 사이트/플랫폼에 퍼져있는 도움의 손길 또는 나눔을 하나의 앱에서 주고받을 수 있게 하고 싶습니다.

## 🗒️ 기술 스택
|분류|기술 스택|
|:---:|------|
|**Framework**|<img src="https://img.shields.io/badge/flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"> <img src="https://img.shields.io/badge/androidstudio-3DDC84?style=for-the-badge&logo=androidstudio&logoColor=white">|
|**Language**|  <img src="https://img.shields.io/badge/dart-0175C2?style=for-the-badge&logo=dart&logoColor=white">|
|**Database**| <img src="https://img.shields.io/badge/firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=white"> |
|**Collaboration**| <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white"> <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white"> <img src="https://img.shields.io/badge/notion-000000?style=for-the-badge&logo=notion&logoColor=white">|

## 📋 구현 기능
![image](https://github.com/ooing-0720/DoNature/assets/87466004/7ffedee9-0001-4f9f-b9ec-af5c4903ead8)
### 1 발효된 기상 특보 확인
Geocoding API를 이용하여 사용자의 위치 정보를 받고, 이를 기반하여 기상청 단기예보 조회 서비스 API를 이용하여 현재 기상 확인<br/>
대처법 안내하기를 통해 기상 특보와 관련된 자세한 현황 확인 가능|

### 2 전국 재난상황 정보 확인
기상특보 조회 서비스 API를 이용하여 전국의 기상 특보 데이터(json)을 크롤링하고 객체로 파싱하여, 벡터 이미지로 나타낸 한반도 지도에 도 별 기상특보를 보여줌

### 3 정보 공유 및 나눔
메인 모델 패턴을 이용하여 게시판과 채팅 기능을 구현하고, Firebase에 데이터를 저장.
<br/>**채팅** : 실시간 채팅, 삭제, 이미지 전송
<br/>**게시판**
- 게시판 클래스(Post)를 이용하여 **Firebase Realtime Database에 CRUD** 및 기능 수행
    - 게시판 목록과 게시글 CRUD
    - 게시글 등록 시 설정한 태그(재난, 글 종류, 지역 등)을 통한 필터링(검색) 기능
    - 관심글 등록과 관심글 목록 출력
    - 유저의 현재 선택한 게시글을 통한 채팅방 생성 여부 확인
    - 유저 정보 변경 시 데이터베이스에 변경된 정보 반영
## 시연 영상
[DoNature 시연 영상](https://www.youtube.com/watch?v=zyVrPF6aUow)

## 성과
2022 공공데이터 기업 매칭 공모전 우수상 수상
