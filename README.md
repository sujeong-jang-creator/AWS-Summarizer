# AWS Service Screener Well-Architected Summarizer

A tool to analyze AWS [Service Screener](https://github.com/aws-samples/service-screener-v2) output data and generate comprehensive Well-Architected Framework analysis reports.

## Overview

The AWS Service Screener Well-Architected Summarizer (wa-ss-summarizer) is a command-line tool that leverages Amazon Q CLI to process Service Screener data and produce detailed HTML reports highlighting security issues, performance optimization opportunities, and actionable recommendations based on the AWS Well-Architected Framework's six pillars.

This tool serves as a wrapper around Amazon Q CLI, providing a streamlined way to analyze Service Screener results and generate professional, actionable reports that can be shared with stakeholders.

## Features

- **Comprehensive Analysis**: Analyzes Service Screener data across all six Well-Architected Framework pillars
- **Priority-Based Recommendations**: Provides actionable recommendations categorized by priority (High, Medium, Low)
- **Implementation Roadmap**: Includes timeline and steps for implementing recommendations
- **Cost Impact Analysis**: Estimates the financial impact of implementing recommendations
- **Visual Reporting**: Generates visually appealing HTML reports with charts and progress indicators
- **AWS CLI Commands**: Includes specific AWS CLI commands for implementing recommendations
- **Service Focus**: Analyzes the top 5 services with the most findings, plus IAM findings

## Prerequisites

- AWS CLI configured with appropriate credentials
- Amazon Q CLI installed and configured
- AWS Service Screener output data

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/carlos-aws/wa-ss-summarizer.git
   cd wa-ss-summarizer
   ```

2. Make the script executable:
   ```bash
   chmod +x run_wa_summarizer.sh
   ```

## Usage

### Basic Usage

```bash
./run_wa_summarizer.sh -d /path/to/service-screener-results
```

### Options

- `-d, --dir DIRECTORY`: Service Screener results directory (required)
- `-o, --output DIRECTORY`: Output directory for reports (default: ./output)
- `-h, --help`: Display help message

### Example

```bash
./run_wa_summarizer.sh -d /path/to/service-screener-results -o ./my-reports
```

## Service Screener Data Structure

The tool expects Service Screener data in the following structure:

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

## Generated Report

The tool generates an HTML report with the following sections:

1. **Summary Dashboard**: Key metrics including issues by severity, pillar distribution, and expected improvement impact
2. **Well-Architected Framework 6 Pillars Analysis**: Analysis of findings for each pillar
3. **Service Screener Results Analysis**: Detailed analysis of the top 5 services with the most findings, plus IAM findings
4. **Priority-based Improvement Recommendations**: Actionable recommendations categorized by priority
5. **Implementation Roadmap**: Timeline and steps for implementing the recommendations
6. **Cost Impact Analysis**: Financial impact of implementing the recommendations
7. **Conclusion and Recommendations**: Summary of key findings and recommendations

## Troubleshooting

### Common Issues

1. **Amazon Q CLI not found**:
   - Ensure Amazon Q CLI is installed and in your PATH
   - Run `q --version` to verify installation

2. **AWS credentials not configured**:
   - Run `aws configure` to set up your AWS credentials
   - Verify with `aws sts get-caller-identity`

3. **Invalid Service Screener data**:
   - Ensure the Service Screener directory contains the expected files and structure
   - Check that at least one account directory exists with index.html and CPFindings.html files

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- AWS Service Screener team for providing the foundation for this tool
- Amazon Q for powering the analysis capabilities
