# Security

## Reporting Security Issues

If you discover a potential security issue, please notify AWS Security via our
[vulnerability reporting page](https://aws.amazon.com/security/vulnerability-reporting/).
Do **not** create a public GitHub issue.

## Shared Responsibility Model

This package provides AI agent configurations that interact with AWS HealthOmics and related services. Under the [AWS Shared Responsibility Model](https://aws.amazon.com/compliance/shared-responsibility-model/):

**AWS is responsible for:**
- Securing the HealthOmics service infrastructure.
- Managing service-linked roles and ENIs created by HealthOmics.
- Encrypting data processed within the HealthOmics execution environment.

**You are responsible for:**
- Configuring IAM roles with least-privilege permissions.
- Securing S3 buckets (encryption, access policies, Block Public Access).
- Configuring VPC security groups, network ACLs, and route tables.
- Managing credentials (AWS credentials, Docker Hub tokens in Secrets Manager).
- Reviewing AI-generated workflow definitions before executing on production or clinical data.
- Complying with applicable regulations (HIPAA, GDPR) for your data.

## Credential Security

- Use IAM roles with least-privilege permissions. Avoid long-lived access keys.
- Enable MFA for IAM users with access to HealthOmics resources.
- Never commit AWS credentials, Docker Hub tokens, or other secrets to version control.
- Rotate credentials regularly. Use Secrets Manager automatic rotation where supported.
- The `.healthomics/config.toml` file contains an IAM role ARN (not a secret), but treat it as sensitive configuration.

## Data Privacy

This package processes genomics workflow data that may include protected health information (PHI). Before processing regulated data:

- Verify your AWS account is covered by a Business Associate Agreement (BAA) if handling HIPAA-regulated data.
- Classify your data and apply appropriate encryption and access controls.
- Enable CloudTrail and S3 access logging for audit trails.
- Review the [AWS HealthOmics compliance documentation](https://aws.amazon.com/compliance/services-in-scope/).

## AI Agent Considerations

AI agents configured by this package can create, modify, and execute genomics workflows. To mitigate risks:

- Review AI-generated workflow definitions before deploying to production.
- Use separate AWS accounts or IAM permission boundaries for development vs. production.
- Monitor workflow execution costs and set billing alarms.
- AI agents do not have access to your AWS credentials directly — they operate through the MCP server which uses your configured AWS CLI credentials.

## S3 Bucket Security

When creating S3 buckets for HealthOmics workflow data:

- Enable S3 Block Public Access.
- Configure default encryption (SSE-S3 minimum; SSE-KMS for sensitive data).
- Add a bucket policy enforcing TLS transport (`aws:SecureTransport` condition).
- Enable versioning for data protection.
- Enable access logging for compliance.

## Dependencies

This package uses the [AWS HealthOmics MCP Server](https://github.com/awslabs/mcp/tree/main/src/aws-healthomics-mcp-server) via `uvx`. The MCP server is fetched from PyPI at runtime. Pin to a specific version in production environments by setting the version in your MCP server configuration.
