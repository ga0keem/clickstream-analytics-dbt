# Clickstream Analytics Pipeline with dbt

클릭스트림 데이터를 기반으로 사용자 행동을 분석하기 위해 dbt로 데이터 파이프라인을 구축했다.  
이벤트 단위 데이터를 세션과 퍼널 구조로 재구성하고, 비즈니스 지표를 포함한 분석용 데이터 마트를 설계했다.


## Overview

본 프로젝트에서는 다음과 같은 단계로 데이터를 구조화하였다.

- 코드 기반 데이터 → 의미 있는 값으로 변환
- 이벤트 → 세션 단위 집계
- 사용자 행동 흐름 → 퍼널 구조로 정리
- 최종적으로 BI에서 바로 사용할 수 있는 분석 테이블 생성


## Data Model


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

## Layer Architecture

### 1. Staging Layer

원본 데이터를 그대로 유지하면서 컬럼명 및 데이터 타입을 정리하는 단계

- raw 데이터를 1:1로 보존
- 최소한의 정제만 수행


### 2. Intermediate Layer

분석을 위한 핵심 로직을 적용하는 단계

- 코드 값 변환 (macro, seed 활용)
- 이벤트 단위 정제 및 중복 제거
- 세션 단위 집계
- 퍼널 구조 생성
- 상품 성과 집계

주요 모델:
- `int_events_enriched`
- `int_sessions`
- `int_session_funnel`
- `int_product_performance`


### 3. Core Layer (Fact / Dimension)

데이터 모델의 구조를 정의하는 단계

#### Fact Tables
- `fct_events`: 이벤트 단위 데이터
- `fct_sessions`: 세션 단위 데이터

#### Dimension Tables
- `dim_products`: 상품 정보
- `dim_users`: 사용자 정보
- `dim_ui`: UI 요소 정보


### 4. Analytics Layer

비즈니스 지표를 포함한 최종 분석 테이블

- `funnel_mart`: 퍼널 단계별 전환 분석
- `product_mart`: 상품 성과 분석
- `ux_mart`: UI 요소 성과 분석
- `country_mart`: 국가별 사용자 행동 분석

---

## Metrics Design

본 프로젝트에서는 이벤트 기준과 세션 기준을 분리하여 지표를 정의하였다.

- 이벤트 기준 지표: 클릭 수, 조회 수
- 세션 기준 지표: 전환율, 탐색 깊이

이를 통해 사용자 행동과 결과를 명확하게 구분하여 분석할 수 있도록 설계하였다.


## Key Design Decisions

- 코드 값을 구조적으로 변환 (macro / seed 활용)
- surrogate key를 활용하여 이벤트 grain 명확화
- 세션 기반 전환 정의 
- 이벤트 지표와 세션 지표를 분리하여 계산
- star schema 기반의 확장 가능한 구조 설계
- BI 도구와 바로 연결 가능한 mart 구성


## How to Run

- dbt run
- dbt test

## Tech Stack
- dbt Cloud
- BigQuery
- SQL
