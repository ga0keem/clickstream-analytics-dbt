# Clickstream Analytics Pipeline with dbt

이 프로젝트는 클릭스트림 데이터를 기반으로 사용자 행동을 분석하기 위한 데이터 파이프라인을 dbt로 구축한 것이다.  
이벤트 단위의 원천 데이터를 정제하고, 세션 및 퍼널 구조를 생성한 뒤, 최종적으로 비즈니스 지표를 포함한 분석 테이블을 설계하는 것을 목표로 한다.

---

## 프로젝트 개요

클릭스트림 데이터는 이벤트 단위로 수집되기 때문에 그대로는 분석에 활용하기 어렵다.  
따라서 본 프로젝트에서는 다음과 같은 단계로 데이터를 구조화하였다.

- 코드 기반 데이터 → 의미 있는 값으로 변환
- 이벤트 → 세션 단위 집계
- 사용자 행동 흐름 → 퍼널 구조로 정리
- 최종적으로 BI에서 바로 사용할 수 있는 분석 테이블 생성

---

## 데이터 모델 구조


```yaml
models/
├── staging/
│   └── stg_clickstream.sql
│
├── intermediate/
│   ├── int_events_enriched.sql
│   ├── int_sessions.sql
│   ├── int_session_funnel.sql
│   └── int_product_performance.sql
│
├── marts/
│   ├── core/
│   │   ├── fct_events.sql
│   │   ├── fct_sessions.sql
│   │   ├── dim_products.sql
│   │   ├── dim_users.sql
│   │   └── dim_ui.sql
│   │
│   └── analytics/
│       ├── funnel_mart.sql
│       ├── product_mart.sql
│       ├── ux_mart.sql
│       └── country_mart.sql
│
└── schema.yml
```

---

## Layer별 역할

### 1. Staging Layer

원본 데이터를 그대로 유지하면서 컬럼명 및 데이터 타입을 정리하는 단계

- raw 데이터를 1:1로 보존
- 최소한의 정제만 수행

---

### 2. Intermediate Layer

분석을 위한 핵심 로직을 적용하는 단계

- 코드 값 변환 (macro, seed, case when)
- 이벤트 단위 정제 및 중복 제거
- 세션 단위 집계
- 퍼널 구조 생성
- 상품 성과 집계

주요 모델:
- `int_events_enriched`
- `int_sessions`
- `int_session_funnel`
- `int_product_performance`

---

### 3. Core Layer (Fact / Dimension)

데이터 모델의 구조를 정의하는 단계

#### Fact Tables
- `fct_events`: 이벤트 단위 데이터
- `fct_sessions`: 세션 단위 데이터

#### Dimension Tables
- `dim_products`: 상품 정보
- `dim_users`: 사용자 정보
- `dim_ui`: UI 요소 정보

---

### 4. Analytics Layer

비즈니스 지표를 포함한 최종 분석 테이블

- `funnel_mart`: 퍼널 단계별 전환 분석
- `product_mart`: 상품 성과 분석
- `ux_mart`: UI 요소 성과 분석
- `country_mart`: 국가별 사용자 행동 분석

---

## 주요 분석 지표

본 프로젝트에서는 이벤트 기준과 세션 기준을 분리하여 지표를 정의하였다.

- 이벤트 기준 지표: 클릭 수, 조회 수
- 세션 기준 지표: 전환율, 탐색 깊이

이를 통해 사용자 행동과 결과를 명확하게 구분하여 분석할 수 있도록 설계하였다.

---

## 설계 특징

- 코드 값을 구조적으로 변환 (macro / seed / case when)
- surrogate key를 활용하여 이벤트 grain 명확화
- 세션 기반 전환 정의 (max_page 기준)
- 이벤트 지표와 세션 지표를 분리하여 계산
- star schema 기반의 확장 가능한 구조 설계
- BI 도구와 바로 연결 가능한 mart 구성

---

## 실행 방법

dbt run
dbt test

## 기술 스택
- dbt Cloud
- BigQuery
- SQL