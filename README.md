# DoNature(도네이처)
<img src="https://github.com/ooing-0720/DoNature/assets/87466004/4c387421-ea28-42d7-ab64-dc3b1655cf0b" width="70%" height="70%"/>

실시간 기후재난 알림, 대처법과 정보 공유 및 나눔 플랫폼(모바일 앱)

## 📍 개요
- 지구온난화로 인한 이상기후로 인해 지역 곳곳에 다양한 기후재난과 그로 인한 피해가 발생하고 있음에도 불구하고, 대부분 거주지가 아닌 다른 지역에서 어떤 기후재난이 일어나고 있으며, 그 위험성과 심각성이 어느 수준인지 인지하지 못함
- 기후재난의 대비책을 세우지 못해 더 큰 피해를 입거나 기후재난으로 피해를 본 이들이 충분한 관심과 지원을 받지 못하는 일이 일어남

## ✅ 목표
- 도네이처에서는 **재난 경보 및 기상 API**를 통해 앱 사용자에게 **사용자의 위치 기반 및 전국 단위의 실시간 기상특보**에 관한 정보를 알리고 **대처법**을 안내함
- **게시판 및 채팅** 기능을 통해 직접 **기후재난 상황**을 알리고, 피해를 본 이들을 위해 **도움을 주고받을** 수 있음

## 🗒️ 기술 스택
<img src="https://img.shields.io/badge/flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"> <img src="https://img.shields.io/badge/visualstudiocode-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white"> <img src="https://img.shields.io/badge/androidstudio-3DDC84?style=for-the-badge&logo=androidstudio&logoColor=white"> <img src="https://img.shields.io/badge/dart-0175C2?style=for-the-badge&logo=dart&logoColor=white"> <img src="https://img.shields.io/badge/firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=white"> <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white"> <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white"> 

## 📋 구현 기능
![image](https://github.com/ooing-0720/DoNature/assets/87466004/7ffedee9-0001-4f9f-b9ec-af5c4903ead8)
### 1 발효된 기상 특보 확인
Geocoding API를 이용하여 사용자의 위치 정보를 받고, 이를 기반하여 기상청 단기예보 조회 서비스 API를 이용하여 현재 기상 확인<br/>
대처법 안내하기를 통해 기상 특보와 관련된 자세한 현황 확인 가능|

### 2 전국 재난상황 정보 확인
기상특보 조회 서비스 API를 이용하여 전국의 기상 특보 데이터(json)을 크롤링하고 객체로 파싱하여, 벡터 이미지로 나타낸 한반도 지도에 도 별 기상특보를 보여줌

### 3 정보 공유 및 나눔
메인 모델 패턴을 이용하여 게시판과 채팅 기능을 구현하고, Firebase에 데이터를 저장.
<br/>게시판 기능 : 게시글 작성, 수정, 삭제, 관심글 등록, 게시글의 작성자와 채팅, 게시판에서 키워드로 검색
<br/>채팅 기능 : 실시간 채팅, 삭제, 이미지 전송

## 시연 영상
[DoNature 시연 영상](https://www.youtube.com/watch?v=zyVrPF6aUow)

## 아쉬운 점
시간 제약과 mac os를 구하지 못해 ios 개발 및 시연을 하지 못함.
