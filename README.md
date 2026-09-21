# 과제 구현 메모

## 1. 실행 방법

### 개발 환경

- Flutter: 3.47.4
- Dart: Flutter SDK 포함 버전
- IDE: VS Code
- OS: macOS 15.6
- Architecture: Apple Silicon (arm64)

### 실행 명령

```bash
flutter pub get
flutter run

### 정적 분석

flutter analyze
```

## 2. 구현 범위

### 관심 종목

- 관심 종목이 없을 때의 Empty 상태
- 검색 화면에서 관심 종목 추가 / 삭제
- 관심 종목의 시세 API 연동
- 종목명 / 종목코드 / 시장 정보 표시
- 현재가 / 전일 대비 금액 / 등락률 표시
- 상승 / 하락 / 보합 상태별 색상 적용

### 종목 검색

- 종목명 / 종목코드 검색
- NAVER 종목 검색 API 연동
- 국내 주식 6자리 종목코드 필터링
- 종목명 / 종목코드 / 시장 정보 표시
- 검색어에 해당하는 종목명 하이라이트
- 검색 결과가 없을 때의 Empty 상태
- 검색어 초기화
- 관심 종목 추가 / 삭제
- 관심 종목 상태에 따른 별 아이콘 변경
- 관심 종목 상태를 관심 화면과 동기화

### 공통

- Figma 디자인 기준 색상 및 간격 적용
- API 응답 데이터와 화면에서 사용하는 모델 분리

## 3.기술 선택과 이유

### 상태 관리

별도의 상태관리 패키지를 사용하지 않고 Flutter의 StatefulWidget과 setState를 사용했습니다.
이번 과제에서 필요한 전역적인 상태가 많지 않고, 관심 종목 상태도 화면 간 공유가 필요한 favoriteStocks 하나를 중심으로 구성되어 있어 별도의 상태관리 라이브러리를 추가하지 않았습니다.
관심 종목 상태는 HomeScreen에서 관리합니다.

HomeScreen
├── favoriteStocks
├── WatchlistScreen
└── SearchScreen

검색 화면에서 관심 종목을 변경하면 onFavoriteChanged를 통해 HomeScreen에 변경 사항을 전달하고, 변경된 상태를 두 화면에서 공유하도록 구성했습니다.

### 폴더 구조

lib/
├── models/
├── screens/
├── services/
├── untils/
├── widgets/
└── theme/

### 데이터 처리 구조

API 응답 데이터를 화면에서 직접 사용하지 않고 DTO와 Model을 분리했습니다.
NAVER API
↓
RealtimeStockDto
↓
convertToStock()
↓
Stock
↓
UI

## 4. 직접 판단한 부분과 이유

### 관심 종목 상태 관리

검색 화면에서 선택한 종목을 관심 화면에서도 동일하게 사용해야 하기 때문에 관심 상태를 각 화면에서 따로 관리하지 않고 HomeScreen에서 관리했습니다.

favoriteStocks는 종목 코드의 중복을 방지하기 위해 Set<String>으로 관리했습니다.

## 5. 막혔던 지점과 어떻게 접근했는지

Flutter를 처음 사용해보는 상황에서 과제를 진행하여, Flutter의 기본적인 위젯 구조와 상태 관리 방식 등을 익히는 데 시간이 필요했습니다.
초기에는 유튜브 기초 강의를 참고하며 Flutter의 기본 구조와 문법을 학습한 후 과제에 적용했습니다.

이후 구현 과정에서 이해하기 어려운 부분이나 오류가 발생한 경우에는 AI를 활용하여 원인과 해결 방법을 확인하고, 코드를 직접 적용하면서 동작을 확인하는 방식으로 진행했습니다.

특히 관심 종목 상태 공유, NAVER API 응답 데이터 처리, API 데이터를 화면에서 사용하는 모델로 변환하는 과정에서 오류가 발생했으며, 각각의 원인을 확인한 후 필요한 부분을 수정하고 실행 결과를 다시 확인하는 방식으로 해결했습니다.
