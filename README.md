# AWS Service Screener Well-Architected 요약 도구
AWS [Service Screener](https://github.com/aws-samples/service-screener-v2) 출력 데이터를 분석하여 Well-Architected Framework 기반의 종합 분석 리포트를 자동 생성하는 도구입니다.

## 개요
AWS Service Screener Well-Architected Summarizer(wa-ss-summarizer)는 Amazon Q CLI를 활용하여 Service Screener 데이터를 처리하고,
AWS Well-Architected Framework 6개 필러에 기반한 상세 HTML 분석 리포트를 생성하는 커맨드라인 도구입니다.

이 도구는 Amazon Q CLI를 감싸는(wrapper) 형태로 동작하며, Service Screener 분석 결과를 더욱 읽기 쉽고 실무적으로 활용 가능한 보고서 형태로 만들어 줍니다.

## Features

- **종합 분석**: Well-Architected Framework 6개 필러 전반에 걸쳐 Service Screener 결과 분석
- **우선순위 기반 권장사항**: High / Medium / Low 로 분류된 개선 권고 제공
- **구현 로드맵 제공**: 권장사항 실행을 위한 단계별 계획 포함
- **비용 영향 분석**: 권장사항 적용 시 예상되는 비용 영향 추정
- **시각화된 레포트**: 차트(Charts), 진행률 표시 등 비주얼 요소 포함한 HTML 리포트 생성
- **AWS CLI 명령어 포함**: 권고된 개선 조치를 수행하기 위한 AWS CLI 명령 자동 포함
- **서비스 중심 분석**: 가장 많은 이슈를 가진 상위 5개 AWS 서비스 + IAM 결과 포함

## 사전 요구사항
- AWS CLI가 적절한 Credential과 함께 설정되어 있어야 함
- Amazon Q CLI 설치 및 구성 완료
- AWS Service Screener 결과 데이터 준비 필요

## 설치 방법

1. repository clone:
   ```bash
   git clone https://github.com/sujeong-jang-creator/AWS-Summarizer
   cd AWS-Summarizer
   ```

2. 스크립트 실행권한 부여:
   ```bash
   chmod +x run_wa_summarizer.sh
   ```

## 사용 방법
### 기본 사용 방법

```bash
./run_wa_summarizer.sh -d /path/to/service-screener-results
```

### 옵션

- `-d, --dir DIRECTORY`: 분석할 Service Screener 결과 디렉토리 (필수)
- `-o, --output DIRECTORY`: 보고서 출력 디렉토리 (기본값: ./output)
- `-h, --help`: 도움말 출력

### 예시

```bash
./run_wa_summarizer.sh -d /path/to/service-screener-results -o ./my-reports
```

## Service Screener 데이터 구조

도구는 아래와 같은 구조의 Screener 데이터 디렉토리를 기대합니다:

```
<service_screener_dir>/
├── <account_id>/
│   ├── all.csv
│   ├── api-full.json
│   ├── api-raw.json
│   ├── CPFindings.html
│   ├── index.html
│   ├── <service>.html (e.g., ec2.html, s3.html)
│   └── <framework>.html (e.g., CIS.html, WAFS.html)
└── res/
    └── (CSS, images, and other resources)
```

## 생성되는 보고서

HTML 리포트는 다음과 같은 섹션을 포함합니다:

1. **요약 대시보드**: 심각도(Severity)별 이슈 요약, 필러별 이슈 분포, 개선 효과 예상치
2. **Well-Architected Framework 6개 필러 분석**
3. **Service Screener 결과 분석**: 가장 많은 이슈를 가진 상위 5개 서비스, IAM 관련 이슈 별도 분석 포함
4. **우선순위 기반 개선 권장사항**
5. **구현 로드맵**: 개선 작업 계획과 일정 예시 제공
6. **비용 영향 분석**
7. **결론 및 종합 권고s**

## Troubleshooting

### Common Issues

1. **AWS 자격증명 미구성**:
   - `aws configure`로 설정
   - `aws sts get-caller-identity`로 인증 확인

2. **잘못된 Service Screener 데이터**:
   - 예상된 디렉토리와 파일이 모두 존재하는지 확인
   - 최소한 index.html과 CPFindings.html 이 있어야 분석 가능

## License
MIT License
(LICENSE 파일 참조)
