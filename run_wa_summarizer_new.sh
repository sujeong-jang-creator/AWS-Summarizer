#!/bin/bash

set -e

# 터미널 가독성용 색 지정
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default settings
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OUTPUT_DIR="${SCRIPT_DIR}/output"
PROMPT_FILE="${SCRIPT_DIR}/src/prompt/wa_summarizer_mod_no-single-line.md"

# Main function
main() {
    # Service Screener 결과가 들어있는 디렉터리 경로
    local service_screener_dir=""
    # 결과물 저장 위치
    local output_dir="$DEFAULT_OUTPUT_DIR"

    # 커맨드 파싱
    # 커맨드: ./run_wa_summarizer.sh -d /tmp/aws
    # service_screener_dir = /tmp/aws
    # output_dir = ./output
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--dir)
                service_screener_dir="$2"
                shift 2
                ;;
            -o|--output)
                output_dir="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Unknown option: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done

    # index.html 파일이 하나도 없으면 오류로 처리
    # → Service Screener 결과 디렉터리가 아니거나 결과 생성이 실패한 경우
    index_files=$(find "$service_screener_dir" -maxdepth 2 -name "index.html" | wc -l)
    if [ "$index_files" -eq 0 ]; then
        echo -e "${RED}❌ No index.html files found in Service Screener directory.${NC}"
        echo -e "${YELLOW}ℹ️ Service Screener directory should contain index.html files in account directories.${NC}"
        exit 1
    fi

    # 최소 하나 이상의 account 디렉터리 하위에 CPFindings.html 파일이 존재하는지 확인
    # (Well-Architected Framework 6 Pillars 분석의 핵심 소스 파일) 
    findings_files=$(find "$service_screener_dir" -maxdepth 2 -name "CPFindings.html" | wc -l)

    # CPFindings.html 파일이 하나도 없으면 오류로 처리
    # → Well-Architected 분석을 수행할 수 없는 상태
    if [ "$findings_files" -eq 0 ]; then
        echo -e "${RED}❌ No CPFindings.html files found in Service Screener directory.${NC}"
        echo -e "${YELLOW}ℹ️ Service Screener directory should contain CPFindings.html files in account directories.${NC}"
        exit 1
    fi

    # 출력 디렉터리가 존재하지 않으면 생성
    # (요약 프롬프트 파일 및 결과 HTML 저장용)
    if [ ! -d "$output_dir" ]; then
        echo -e "${YELLOW}ℹ️ Creating output directory: $output_dir${NC}"
        mkdir -p "$output_dir"

        # 디렉터리 생성 실패 시 즉시 종료
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ Failed to create output directory: $output_dir${NC}"
            exit 1
        fi
    fi

    # 출력 디렉터리에 쓰기 권한이 있는지 확인
    # (prompt_*.md 파일 생성 및 결과 파일 저장을 위해 필요)
    if [ ! -w "$output_dir" ]; then
        echo -e "${RED}❌ Output directory is not writable: $output_dir${NC}"
        exit 1
    fi

    # 현재 날짜와 시간을 기준으로 타임스탬프 생성
    # 형식: YYYYMMDD_HHMMSS (예: 20260109_143522)
    timestamp=$(date +"%Y%m%d_%H%M%S")

    # 타임스탬프를 포함한 결과 HTML 파일명 생성
    # → 실행할 때마다 파일명이 달라져 기존 결과를 덮어쓰지 않음
    report_filename="wa_summary_report_${timestamp}.html"

    # output 디렉터리 기준으로 최종 결과 파일 전체 경로 생성
    # (현재 스크립트에서는 실제로는 사용되지 않지만, 결과 저장용 변수)
    report_path="${output_dir}/${report_filename}"

    echo -e "${GREEN}✅ Service Screener directory validated: $service_screener_dir${NC}"
    echo -e "${GREEN}📊 Output directory: $output_dir${NC}"
    echo -e "${GREEN}📄 Report will be saved as: $report_filename${NC}"
    echo -e "${YELLOW}🚀 Starting AWS Service Screener Well-Architected Summarizer...${NC}"
    echo ""

    # Amazon Q CLI 확인
    if ! command -v q &> /dev/null; then
        echo -e "${RED}❌ Amazon Q CLI is not installed.${NC}"
        echo -e "${YELLOW}ℹ️ Please install Amazon Q CLI before running this tool.${NC}"
        exit 1
    fi

    # AWS credentials 확인
    if ! aws sts get-caller-identity &> /dev/null; then
        echo -e "${RED}❌ AWS credentials are not configured.${NC}"
        echo -e "${YELLOW}ℹ️ Please configure AWS credentials using 'aws configure' before running this tool.${NC}"
        exit 1
    fi

    # Prompt file 존재 여부 확인
    if [ ! -f "$PROMPT_FILE" ]; then
        echo -e "${RED}❌ Prompt file does not exist: $PROMPT_FILE${NC}"
        exit 1
    fi

    # Service Screener 데이터 분석 시작 안내 메시지 출력
    # (실제 분석은 Amazon Q가 수행)
    echo -e "${YELLOW}📊 Analyzing Service Screener data...${NC}"
    
    # Service Screener 결과 디렉터리 경로를 포함한 프롬프트 파일 생성 준비
    # 실행 시점의 timestamp를 포함하여 파일명 충돌 방지
    prompt_file="${output_dir}/prompt_${timestamp}.md"

    # wa_summarizer.md 템플릿 파일에서
    # {SERVICE_SCREENER_DIR} 플레이스홀더를 실제 Service Screener 디렉터리 경로로 치환
    # 치환된 결과를 output 디렉터리 하위에 새로운 프롬프트 파일로 저장
    sed "s|{SERVICE_SCREENER_DIR}|$service_screener_dir|g" "$PROMPT_FILE" > "$prompt_file"
    
    # Amazon Q CLI로 프롬프트 전송 시작 안내 메시지 출력
    echo -e "${YELLOW}🤖 Sending request to Amazon Q...${NC}"

    # 생성된 프롬프트 파일 내용을 Amazon Q CLI의 입력으로 전달
    # q chat은 표준 입력(stdin)을 통해 프롬프트를 받아 분석을 수행
    # 결과는 표준 출력(stdout)으로 그대로 출력됨
    cat "$prompt_file" | q chat --trust-all-tools
    
    # 직전에 실행한 명령(q chat)의 종료 코드 확인
    # 종료 코드 0은 정상 종료를 의미
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ AWS Service Screener Well-Architected Summarizer completed!${NC}"
    else
        echo -e "${RED}❌ Failed to generate report.${NC}"
        exit 1
    fi
}

# Execute the main function
main "$@"
