## Context

### Service Screener Results Tree

<service_screener_results_tree>

Results from Service Screener scan follow a directory tree like below:

```text
aws
.
├── ./012345678901
│   ├── ./012345678901/all.csv
│   ├── ./012345678901/api-full.json
│   ├── ./012345678901/api-raw.json
│   ├── ./012345678901/apigateway.html
│   ├── ./012345678901/CIS.html
│   ├── ./012345678901/cloudfront.html
│   ├── ./012345678901/cloudtrail.html
│   ├── ./012345678901/cloudwatch.html
│   ├── ./012345678901/CPFindings.html
│   ├── ./012345678901/CPModernize.html
│   ├── ./012345678901/CPTA.html
│   ├── ./012345678901/dynamodb.html
│   ├── ./012345678901/ec2.html
│   ├── ./012345678901/efs.html
│   ├── ./012345678901/eks.html
│   ├── ./012345678901/elasticache.html
│   ├── ./012345678901/error.txt
│   ├── ./012345678901/FTR.html
│   ├── ./012345678901/guardduty.html
│   ├── ./012345678901/iam.html
│   ├── ./012345678901/index.html
│   ├── ./012345678901/kms.html
│   ├── ./012345678901/lambda.html
│   ├── ./012345678901/MSR.html
│   ├── ./012345678901/NIST.html
│   ├── ./012345678901/opensearch.html
│   ├── ./012345678901/RBI.html
│   ├── ./012345678901/rds.html
│   ├── ./012345678901/redshift.html
│   ├── ./012345678901/RMiT.html
│   ├── ./012345678901/s3.html
│   ├── ./012345678901/SPIP.html
│   ├── ./012345678901/sqs.html
│   ├── ./012345678901/SSB.html
│   ├── ./012345678901/WAFS.html
│   └── ./012345678901/workItem.xlsx
└── ./res  (This directory contains a series of CSS, img and other files for the HTML report to render properly)
</service_screener_results_tree>

<navigating_service_screener_data>

The global summary report aws/<acount_id>/index.html contains a summary of findings based on the Service Screener check results (e.g. High, Medium, Low and Informational).

Be mindful that there is a distinct separation on the Service Screener HTML files:

Compliance and Framework related results
The CIS (CIS Amazon Web Services Foundations Benchmark), FTR (Foundational Technical Review), MSR (MSR baseline checks), NIST (National Institute of Standards and Technology), RBI (Reserve Bank of India (RBI) Cloud Computing Guidelines), RMIT (Bank Negara Malaysia (BNM) Risk Management in Technology (RMiT)), SPIP (AWS Security Posture Improvement Program (SPIP)), SSB (AWS Startup Security Baseline) and WAFS (AWS Well-Architected Framework - Security Pillar).

Service specific findings
Any of the other HTMLs, with the exception of index.html, CPFindings.html, CPModernize.html and CPTA.html.

Use below bash command to get a summary of number of resources scanned and findings from Service Screener results:

for account in <acount_id>; do
  echo "=== Account $account ==="
  echo "=== Global Summary ==="
  echo "Overall Severity Distribution:"

  HIGH=$(grep -A1 'fa-ban.*High' "$account/index.html" 2>/dev/null \
    | grep -o 'text-align: right.*[0-9]\+' \
    | grep -o '[0-9]\+' || echo "N/A")
  MEDIUM=$(grep -A1 'fa-exclamation-triangle.*Medium' "$account/index.html" 2>/dev/null \
    | grep -o 'text-align: right.*[0-9]\+' \
    | grep -o '[0-9]\+' || echo "N/A")
  LOW=$(grep -A1 'fa-eye.*Low' "$account/index.html" 2>/dev/null \
    | grep -o 'text-align: right.*[0-9]\+' \
    | grep -o '[0-9]\+' || echo "N/A")
  INFO=$(grep -A1 'fa-info-circle.*Informational' "$account/index.html" 2>/dev/null \
    | grep -o 'text-align: right.*[0-9]\+' \
    | grep -o '[0-9]\+' || echo "N/A")

  echo "  High: $HIGH"
  echo "  Medium: $MEDIUM"
  echo "  Low: $LOW"
  echo "  Informational: $INFO"

  echo "AWS Well-Architected Framework Pillars:"

  SEC_BLOCK=$(grep -A30 'CPFindings.html#Security' "$account/index.html" 2>/dev/null || echo "")
  SEC_TOTAL=$(echo "$SEC_BLOCK" | grep -o '<h3>[0-9]\+</h3>' | head -1 | sed 's/<[^>]*>//g' || echo "N/A")
  SEC_HIGH=$(echo "$SEC_BLOCK" | grep -o '<i class=\"fas fa-ban\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  SEC_MED=$(echo "$SEC_BLOCK" | grep -o '<i class=\"fas fa-exclamation-triangle\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  SEC_LOW=$(echo "$SEC_BLOCK" | grep -o '<i class=\"fas fa-eye\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  SEC_INFO=$(echo "$SEC_BLOCK" | grep -o '<i class=\"fas fa-info-circle\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  echo "  Security: Total=$SEC_TOTAL (High=$SEC_HIGH, Medium=$SEC_MED, Low=$SEC_LOW, Info=$SEC_INFO)"

  REL_BLOCK=$(grep -A30 'CPFindings.html#Reliability' "$account/index.html" 2>/dev/null || echo "")
  REL_TOTAL=$(echo "$REL_BLOCK" | grep -o '<h3>[0-9]\+</h3>' | head -1 | sed 's/<[^>]*>//g' || echo "N/A")
  REL_HIGH=$(echo "$REL_BLOCK" | grep -o '<i class=\"fas fa-ban\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  REL_MED=$(echo "$REL_BLOCK" | grep -o '<i class=\"fas fa-exclamation-triangle\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  REL_LOW=$(echo "$REL_BLOCK" | grep -o '<i class=\"fas fa-eye\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  REL_INFO=$(echo "$REL_BLOCK" | grep -o '<i class=\"fas fa-info-circle\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  echo "  Reliability: Total=$REL_TOTAL (High=$REL_HIGH, Medium=$REL_MED, Low=$REL_LOW, Info=$REL_INFO)"

  COST_BLOCK=$(grep -A30 'CPFindings.html#Cost Optimization' "$account/index.html" 2>/dev/null || echo "")
  COST_TOTAL=$(echo "$COST_BLOCK" | grep -o '<h3>[0-9]\+</h3>' | head -1 | sed 's/<[^>]*>//g' || echo "N/A")
  COST_HIGH=$(echo "$COST_BLOCK" | grep -o '<i class=\"fas fa-ban\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  COST_MED=$(echo "$COST_BLOCK" | grep -o '<i class=\"fas fa-exclamation-triangle\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  COST_LOW=$(echo "$COST_BLOCK" | grep -o '<i class=\"fas fa-eye\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  COST_INFO=$(echo "$COST_BLOCK" | grep -o '<i class=\"fas fa-info-circle\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  echo "  Cost Optimization: Total=$COST_TOTAL (High=$COST_HIGH, Medium=$COST_MED, Low=$COST_LOW, Info=$COST_INFO)"

  PERF_BLOCK=$(grep -A30 'CPFindings.html#Performance Efficiency' "$account/index.html" 2>/dev/null || echo "")
  PERF_TOTAL=$(echo "$PERF_BLOCK" | grep -o '<h3>[0-9]\+</h3>' | head -1 | sed 's/<[^>]*>//g' || echo "N/A")
  PERF_HIGH=$(echo "$PERF_BLOCK" | grep -o '<i class=\"fas fa-ban\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  PERF_MED=$(echo "$PERF_BLOCK" | grep -o '<i class=\"fas fa-exclamation-triangle\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  PERF_LOW=$(echo "$PERF_BLOCK" | grep -o '<i class=\"fas fa-eye\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  PERF_INFO=$(echo "$PERF_BLOCK" | grep -o '<i class=\"fas fa-info-circle\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  echo "  Performance Efficiency: Total=$PERF_TOTAL (High=$PERF_HIGH, Medium=$PERF_MED, Low=$PERF_LOW, Info=$PERF_INFO)"

  OP_BLOCK=$(grep -A30 'CPFindings.html#Operation Excellence' "$account/index.html" 2>/dev/null || echo "")
  OP_TOTAL=$(echo "$OP_BLOCK" | grep -o '<h3>[0-9]\+</h3>' | head -1 | sed 's/<[^>]*>//g' || echo "N/A")
  OP_HIGH=$(echo "$OP_BLOCK" | grep -o '<i class=\"fas fa-ban\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  OP_MED=$(echo "$OP_BLOCK" | grep -o '<i class=\"fas fa-exclamation-triangle\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  OP_LOW=$(echo "$OP_BLOCK" | grep -o '<i class=\"fas fa-eye\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  OP_INFO=$(echo "$OP_BLOCK" | grep -o '<i class=\"fas fa-info-circle\"></i> [0-9]\+' | grep -o '[0-9]\+' || echo "N/A")
  echo "  Operational Excellence: Total=$OP_TOTAL (High=$OP_HIGH, Medium=$OP_MED, Low=$OP_LOW, Info=$OP_INFO)"

  echo "=== COMPLIANCE FRAMEWORKS ==="
  echo "CIS (CIS Amazon Web Services Foundations Benchmark):"
  grep -o "Summary: \[.*\]" "$account/CIS.html" 2>/dev/null || echo "No CIS data"

  echo "FTR (Foundational Technical Review):"
  grep -o "Summary: \[.*\]" "$account/FTR.html" 2>/dev/null || echo "No FTR data"

  echo "MSR (MSR baseline checks):"
  grep -o "Summary: \[.*\]" "$account/MSR.html" 2>/dev/null || echo "No MSR data"

  echo "NIST (National Institute of Standards and Technology):"
  grep -o "Summary: \[.*\]" "$account/NIST.html" 2>/dev/null || echo "No NIST data"

  echo "RBI (Reserve Bank of India Cloud Computing Guidelines):"
  grep -o "Summary: \[.*\]" "$account/RBI.html" 2>/dev/null || echo "No RBI data"

  echo "RMiT (Bank Negara Malaysia Risk Management in Technology):"
  grep -o "Summary: \[.*\]" "$account/RMiT.html" 2>/dev/null || echo "No RMiT data"

  echo "SPIP (AWS Security Posture Improvement Program):"
  grep -o "Summary: \[.*\]" "$account/SPIP.html" 2>/dev/null || echo "No SPIP data"

  echo "SSB (AWS Startup Security Baseline):"
  grep -o "Summary: \[.*\]" "$account/SSB.html" 2>/dev/null || echo "No SSB data"

  echo "WAFS (AWS Well-Architected Framework - Security Pillar):"
  grep -o "Summary: \[.*\]" "$account/WAFS.html" 2>/dev/null || echo "No WAFS data"

  echo "=== SERVICE-SPECIFIC FINDINGS ==="
  for svc in apigateway cloudfront cloudtrail cloudwatch dynamodb ec2 efs eks elasticache guardduty iam kms lambda opensearch rds redshift s3 sqs; do
    SVC_UPPER=$(echo $svc | tr '[:lower:]' '[:upper:]')
    echo "$SVC_UPPER:"
    grep -o "<h3>[0-9]*</h3>" "$account/$svc.html" 2>/dev/null | head -2 \
      | sed 's/<[^>]*>//g' | paste - - \
      | awk '{print "Resources: " $1 ", Findings: " $2}' || echo "No $SVC_UPPER data"
  done

  echo
done

For any of the Framework or Compliance related HTML files (e.g. aws/<account_id>/WAFS.html), you can look for summary and detailed information as per below:

Check on <div class='card-header'><h3 class='card-title'>Summary: for the summary counting.

For in-depth details: Check on the table (line after:
<table id='screener-framework' class='table table-bordered table-striped'> <thead><tr><th>Category</th><th>Rule ID</th><th>Compliance Status</th><th>Description</th><th>Reference</th></tr></thead>)
for list details about this particular Framework or Compliance HTML file.

For any of the service related HTML files (e.g. aws/<account_id>/iam.html) except for the guardduty.html, you can look for summary and detailed information as per below:

Check on line above <p>Total Findings</p> for the number of total findings for that particular service.

Check on line above <p>Resources</p> for the number of total service specific resources scanned.

For in-depth details:

Check and review all lines that contains <dl><dt>Description</dt><dd class='detail-desc'> for Service Screener check detail and flagged resources grouped by Service Screener Check.

Also, you can review anything from </div><h5 class=\"mt-4 mb-2\">Detail</h5> until <footer class='main-footer'> finding grouped by flagged resources.

For GuardDuty related results, in file aws/<account_id>/guardduty.html:

Review anything from <div class='card-header'><h3 class='card-title'>All findings</h3> until <footer class='main-footer'> for any GuardDuty related findings.

You can use below bash script to get a full markdown-formatted table of the aws/<account_id>/CPFindings.html file. Useful to get resources flagged per Type (Security, Reliability, Cost Optimization, Performance Efficiency, Operation Excellence) or Severity (High, Medium, Low, and Informational):

cat <acount_id>/CPFindings.html \
  | grep -o '<tr><td>[^<]*</td><td>[^<]*</td><td>[^<]*</td><td>[^<]*</td><td>[^<]*</td><td>[^<]*</td><td>[^<]*</td></tr>' \
  | sed 's/<tr><td>//g; s/<\/td><td>/|/g; s/<\/td><\/tr>//g' \
  | awk -F'|' -v type="$1" -v severity="$2" '
    BEGIN {
      print "# AWS Service Screener Findings\n"
      print "| Service | Region | Check | Type | ResourceID | Severity | Status |"
      print "|---------|--------|-------|------|-----------|----------|--------|"
    }
    {
      if ((type=="" || $4==type) && (severity=="" || $6==severity))
        print "| " $1 " | " $2 " | " $3 " | " $4 " | " $5 " | " $6 " | " $7 " |"
    }'
</navigating_service_screener_data>

<wa_html_summary_report>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AWS Service Screener Well-Architected Framework Analysis Report</title>
    <style>
        :root {
            --primary-blue: #1E40AF;
            --secondary-blue: #3B82F6;
            --light-blue: #DBEAFE;
            --aws-orange: #FF9900;
            --success-green: #10B981;
            --warning-yellow: #F59E0B;
            --danger-red: #EF4444;
            --white: #FFFFFF;
            --gray-50: #F9FAFB;
            --gray-100: #F3F4F6;
            --gray-200: #E5E7EB;
            --gray-300: #D1D5DB;
            --gray-600: #4B5563;
            --gray-800: #1F2937;
            --gray-900: #111827;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: var(--gray-800);
            background-color: var(--gray-50);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background: linear-gradient(135deg, var(--primary-blue), var(--secondary-blue));
            color: var(--white);
            padding: 40px 0;
            text-align: center;
            margin-bottom: 30px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(30, 64, 175, 0.2);
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }

        .summary-dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .summary-card {
            background: var(--white);
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border-left: 5px solid var(--primary-blue);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .summary-card h3 {
            color: var(--primary-blue);
            font-size: 1.3rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .metric {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            padding: 8px 0;
            border-bottom: 1px solid var(--gray-200);
        }

        .metric:last-child {
            border-bottom: none;
        }

        .metric-label {
            font-weight: 600;
            color: var(--gray-600);
        }

        .metric-value {
            font-weight: 700;
            font-size: 1.1rem;
        }

        .high { color: var(--danger-red); }
        .medium { color: var(--warning-yellow); }
        .low { color: var(--secondary-blue); }
        .info { color: var(--gray-600); }

        .pillar-scores {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 40px;
        }

        .pillar-card {
            background: var(--white);
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .pillar-card:hover {
            transform: translateY(-3px);
        }

        .pillar-name {
            font-weight: 700;
            color: var(--primary-blue);
            margin-bottom: 10px;
            font-size: 1.1rem;
        }

        .pillar-score {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 5px;
        }

        .pillar-total {
            color: var(--gray-600);
            font-size: 0.9rem;
        }

        .section {
            background: var(--white);
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .section h2 {
            color: var(--primary-blue);
            font-size: 1.8rem;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 3px solid var(--light-blue);
        }

        .issue-item {
            background: var(--gray-50);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            border-left: 4px solid var(--secondary-blue);
        }

        .issue-header {
            display: flex;
            justify-content: between;
            align-items: flex-start;
            margin-bottom: 10px;
        }

        .issue-title {
            font-weight: 700;
            color: var(--gray-800);
            font-size: 1.1rem;
            flex: 1;
        }

        .issue-severity {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .severity-high {
            background-color: var(--danger-red);
            color: var(--white);
        }

        .severity-medium {
            background-color: var(--warning-yellow);
            color: var(--white);
        }

        .severity-low {
            background-color: var(--secondary-blue);
            color: var(--white);
        }

        .severity-info {
            background-color: var(--gray-600);
            color: var(--white);
        }

        .issue-description {
            color: var(--gray-600);
            margin-bottom: 15px;
            line-height: 1.6;
        }

        .affected-resources {
            background: var(--white);
            border-radius: 6px;
            padding: 15px;
            margin-top: 10px;
        }

        .affected-resources h4 {
            color: var(--primary-blue);
            margin-bottom: 10px;
            font-size: 1rem;
        }

        .resource-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .resource-tag {
            background: var(--light-blue);
            color: var(--primary-blue);
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-family: monospace;
        }

        .recommendations {
            background: var(--success-green);
            color: var(--white);
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
        }

        .recommendations h4 {
            margin-bottom: 10px;
            font-size: 1rem;
        }

        .architecture-diagram {
            background: var(--white);
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .mermaid {
            background: var(--gray-50);
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
        }

        .footer {
            text-align: center;
            padding: 30px;
            color: var(--gray-600);
            border-top: 1px solid var(--gray-200);
            margin-top: 40px;
        }

        .progress-bar {
            width: 100%;
            height: 8px;
            background-color: var(--gray-200);
            border-radius: 4px;
            overflow: hidden;
            margin-top: 5px;
        }

        .progress-fill {
            height: 100%;
            transition: width 0.3s ease;
        }

        .icon {
            width: 20px;
            height: 20px;
            display: inline-block;
        }

        .cost-analysis {
            display: grid;
            gap: 20px;
        }

        .cost-item {
            background: var(--white);
            border-radius: 8px;
            padding: 20px;
            border-left: 4px solid var(--primary-blue);
        }

        .cost-details {
            margin-top: 15px;
        }

        .cost-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid var(--gray-200);
        }

        .cost-increase {
            color: var(--danger-red);
            font-weight: 600;
        }

        .cost-savings {
            color: var(--success-green);
            font-weight: 600;
        }

        .cost-total {
            font-size: 1.1rem;
            font-weight: 700;
            padding: 15px 0;
            border-top: 2px solid var(--primary-blue);
            margin-top: 10px;
        }

        .cost-positive {
            color: var(--success-green);
        }

        .roi-analysis {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .roi-metric {
            text-align: center;
            padding: 15px;
            background: var(--gray-50);
            border-radius: 8px;
        }

        .roi-label {
            font-size: 0.9rem;
            color: var(--gray-600);
            margin-bottom: 5px;
        }

        .roi-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-blue);
        }

        .conclusion {
            background: var(--gray-50);
            border-radius: 12px;
            padding: 30px;
        }

        .conclusion-summary {
            margin-bottom: 30px;
        }

        .key-findings {
            margin-top: 20px;
        }

        .key-findings ul {
            margin-left: 20px;
        }

        .conclusion-recommendations {
            margin-bottom: 30px;
        }

        .recommendation-item {
            margin-bottom: 20px;
            padding: 15px;
            background: var(--white);
            border-radius: 8px;
            border-left: 4px solid var(--primary-blue);
        }

        .recommendation-item h4 {
            color: var(--primary-blue);
            margin-bottom: 10px;
        }

        .recommendation-item ul {
            margin-left: 20px;
        }

        .conclusion-benefits {
            margin-bottom: 30px;
        }

        .benefits-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .benefit-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 20px;
            background: var(--white);
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .benefit-icon {
            font-size: 2rem;
        }

        .benefit-content h4 {
            color: var(--primary-blue);
            margin-bottom: 5px;
        }

        .next-steps {
            background: var(--white);
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid var(--success-green);
        }

        .next-steps h3 {
            color: var(--success-green);
            margin-bottom: 15px;
        }

        .next-steps ol {
            margin-left: 20px;
        }

        .next-steps li {
            margin-bottom: 10px;
        }

        .appendix {
            background: var(--gray-50);
            padding: 20px;
            border-radius: 8px;
        }

        .appendix h3 {
            color: var(--primary-blue);
            margin-bottom: 15px;
        }

        .appendix ul {
            margin-left: 20px;
            margin-bottom: 20px;
        }

        .appendix a {
            color: var(--primary-blue);
            text-decoration: none;
        }

        .appendix a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            .header h1 {
                font-size: 2rem;
            }

            .summary-dashboard {
                grid-template-columns: 1fr;
            }

            .pillar-scores {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>🏗️ AWS Service Screener Well-Architected Framework Analysis Report</h1>
            <p>Account ID: 123456789012 | Generated: July 21, 2025 07:50:41 (KST)</p>
        </div>

        <!-- Summary Dashboard -->
        <div class="summary-dashboard">
            <div class="summary-card">
                <h3>📊 Service Screener Issues Found</h3>
                <div class="metric">
                    <span class="metric-label">High Severity</span>
                    <span class="metric-value high">433</span>
                </div>
                <div class="metric">
                    <span class="metric-label">Medium Severity</span>
                    <span class="metric-value medium">544</span>
                </div>
                <div class="metric">
                    <span class="metric-label">Low Severity</span>
                    <span class="metric-value low">592</span>
                </div>
                <div class="metric">
                    <span class="metric-label">Informational</span>
                    <span class="metric-value info">125</span>
                </div>
                <div class="metric">
                    <span class="metric-label">Total Issues</span>
                    <span class="metric-value">1,694</span>
                </div>
            </div>

            <div class="summary-card">
                <h3>🔒 Security Issues Status</h3>
                <div class="metric">
                    <span class="metric-label">High Security Issues</span>
                    <span class="metric-value high">274</span>
                </div>
                <div class="metric">
                    <span class="metric-label">Medium Security Issues</span>
                    <span class="metric-value medium">132</span>
                </div>
                <div class="metric">
                    <span class="metric-label">Low Security Issues</span>
                    <span class="metric-value low">269</span>
                </div>
                <div class="metric">
                    <span class="metric-label">Total Security Issues</span>
                    <span class="metric-value">706</span>
                </div>
            </div>

            <div class="summary-card">
                <h3>📈 Expected Improvement Impact</h3>
                <div class="metric">
                    <span class="metric-label">Security Enhancement</span>
                    <span class="metric-value success-green">706 issues resolved</span>
                </div>
                <div class="metric">
                    <span class="metric-label">Cost Optimization</span>
                    <span class="metric-value success-green">297 issues resolved</span>
                </div>
                <div class="metric">
                    <span class="metric-label">Performance Improvement</span>
                    <span class="metric-value success-green">339 issues resolved</span>
                </div>
                <div class="metric">
                    <span class="metric-label">Reliability Enhancement</span>
                    <span class="metric-value success-green">210 issues resolved</span>
                </div>
            </div>
        </div>

        <!-- Well-Architected Pillar Scores -->
        <div class="pillar-scores">
            <div class="pillar-card">
                <div class="pillar-name">🔒 Security</div>
                <div class="pillar-score high">706</div>
                <div class="pillar-total">Total Issues</div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 42%; background-color: var(--danger-red);"></div>
                </div>
            </div>
            <div class="pillar-card">
                <div class="pillar-name">⚡ Performance Efficiency</div>
                <div class="pillar-score medium">339</div>
                <div class="pillar-total">Total Issues</div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 20%; background-color: var(--warning-yellow);"></div>
                </div>
            </div>
            <div class="pillar-card">
                <div class="pillar-name">💰 Cost Optimization</div>
                <div class="pillar-score medium">297</div>
                <div class="pillar-total">Total Issues</div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 18%; background-color: var(--secondary-blue);"></div>
                </div>
            </div>
            <div class="pillar-card">
                <div class="pillar-name">🛡️ Reliability</div>
                <div class="pillar-score medium">210</div>
                <div class="pillar-total">Total Issues</div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 12%; background-color: var(--success-green);"></div>
                </div>
            </div>
            <div class="pillar-card">
                <div class="pillar-name">🔧 Operational Excellence</div>
                <div class="pillar-score low">142</div>
                <div class="pillar-total">Total Issues</div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 8%; background-color: var(--gray-600);"></div>
                </div>
            </div>
        </div>

        <!-- Service Screener Results Analysis -->
        <div class="section">
            <h2>🔍 Service Screener Results Analysis</h2>

            <!-- (중간 내용 그대로, 생략 없이 복사) -->
            <!-- EC2 / RDS / S3 / IAM issue-item 블럭 전체 -->
            <!-- Well-Architected 6 Pillars Analysis, Priority-based Recommendations,
                 Implementation Roadmap, Cost Impact, Conclusion & Appendix 부분도
                 원문 그대로 유지해서 붙여 넣으시면 됩니다. -->
        </div>

        <!-- 이하 나머지 HTML 본문은 원문과 동일하게 유지 -->
        <!-- ... 전체 내용 그대로 ... -->

    </div>

    <script>
        // Progress bar animation
        document.addEventListener('DOMContentLoaded', function() {
            const progressBars = document.querySelectorAll('.progress-fill');
            progressBars.forEach(bar => {
                const width = bar.style.width;
                bar.style.width = '0%';
                setTimeout(() => {
                    bar.style.width = width;
                }, 500);
            });
        });

        // Section toggle functionality
        function toggleSection(element) {
            const content = element.nextElementSibling;
            const isVisible = content.style.display !== 'none';
            content.style.display = isVisible ? 'none' : 'block';
            element.querySelector('.toggle-icon').textContent = isVisible ? '▶' : '▼';
        }

        // Print functionality
        function printReport() {
            window.print();
        }

        // Scroll to top
        function scrollToTop() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        // Show scroll to top button on scroll
        window.addEventListener('scroll', function() {
            const scrollBtn = document.getElementById('scrollToTop');
            if (scrollBtn) {
                scrollBtn.style.display = window.pageYOffset > 300 ? 'block' : 'none';
            }
        });
    </script>

    <!-- Scroll to top button -->
    <button id="scrollToTop" onclick="scrollToTop()" style="
        display: none;
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: var(--primary-blue);
        color: white;
        border: none;
        border-radius: 50%;
        width: 50px;
        height: 50px;
        cursor: pointer;
        box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        z-index: 1000;
    ">↑</button>
</body>
</html>

</wa_html_summary_report>

Your Instructions - AWS Service Screener Well-Architected Framework Analysis

You are a cloud architecture expert and AWS Well-Architected Framework specialist. Your task is to analyze AWS Service Screener output data located at {SERVICE_SCREENER_DIR} and generate a comprehensive Well-Architected Framework analysis report as per the HTML format provided in the <wa_html_summary_report> section.

Service Screener Data Structure

The AWS Service Screener data is organized as provided in the example within the <service_screener_results_tree> section above.

Navigating and retrieving information from the AWS Service Screener output directory

Before and while generating the HTML report, follow the methods and recommendations for retrieving AWS Service Screener data as described within the <navigating_service_screener_data> section above.

Analysis Requirements

Analyze the Service Screener data as described within the <navigating_service_screener_data> section above to identify security issues, performance optimization opportunities, and other findings across all six Well-Architected Framework pillars.

Focus on the TOP 5 services with the most findings, prioritized by severity (High, then Medium, then Low). Always include IAM findings regardless of their ranking. Use the methods as described within the <navigating_service_screener_data> section above to pull this information effectively.

Extract Well-Architected Framework pillar information from the CPFindings.html file by filtering for the Type column, which maps to the six pillars. Use the methods as described within the <navigating_service_screener_data> section above to pull this information effectively.

DO NOT try to fetch information from the files:
/<account_id>/workItem.xlsx,
/<account_id>/all.csv,
/<account_id>/api-full.json,
/<account_id>/api-raw.json,
or from any file within /<account_id>/res/.

Generate HTML Report

Based on the information you have extracted from the TOP-5 services, generate an HTML report following the guidelines below without creating or executing separate scripts (As reference, within the square brackets in each step below, you have the different section headers from the provided <wa_html_summary_report> example):

Service Screener Summary Dashboard
["AWS Service Screener Well-Architected Framework Analysis Report", "Service Screener Issues Found", "Security Issues Status"]
Overall assessment and Security Issues Status score with Critical/High/Medium/Low findings count breakdown and SPIP compliance status overview.

Well-Architected Framework 6 Pillars Analysis
["Well-Architected Framework 6 Pillars Analysis"]

Operational Excellence Assessment

Security Assessment

Reliability Assessment

Performance Efficiency Assessment

Cost Optimization Assessment

Sustainability Assessment

Detailed Findings Analysis
["Service Screener Results Analysis"]
Service-specific recommendations with priority levels, resource-specific improvement opportunities, configuration optimization suggestions, best practices alignment gaps.

Risk Assessment and Prioritization
["Priority-based Improvement Recommendations"]
High/Medium/Low priority, business risk assessment, mitigation strategies, actionable steps with AWS CLI.

Implementation Roadmap
["Implementation Roadmap"]
Immediate (0–30 days), short-term (1–6 months), long-term (6–24 months), resource and budget considerations.

Cost-Benefit Analysis
["Cost Impact Analysis"]
Cost savings, investment, ROI, payback period, operational efficiency gains.

Conclusion and Appendix
["Conclusion and Recommendations", "Appendix"]
Follow the structure shown in <wa_html_summary_report>.

Important Notes

The report should be visually appealing and easy to navigate.

Use color coding to highlight severity (red for high, yellow for medium, blue for low).

Include progress bars and visual elements to enhance readability.

Organize information in a logical, hierarchical structure.

Make the report responsive and readable on different devices.

Provide realistic cost estimates and timelines.

Analyze the Service Screener data thoroughly and generate a comprehensive Well-Architected Framework analysis HTML report that follows the provided guidelines and instructions. The report should be in HTML format and saved as:

wa_summary_report_review_{YYYYMMDD_HHMMSS}.html

in the current location's output/ folder (Timezone: UTC).