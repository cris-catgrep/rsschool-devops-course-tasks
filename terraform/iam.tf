# Deploy IAM role for github actions
resource "aws_iam_role" "GithubActionsRole" {
  name        = "GithubActionsRole"
  description = "Necesary permissions for the GitHubActionsRole role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Federated : "arn:aws:iam::378084047153:oidc-provider/token.actions.githubusercontent.com"
        },
        Action : "sts:AssumeRoleWithWebIdentity",
        Condition : {
          StringEquals : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          StringLike : {
            "token.actions.githubusercontent.com:sub" : "repo:cris-catgrep/rsschool-devops-course-tasks:*"
          }
        }
      }
    ]
  })
}

# Allow dynamodb minimum permissions to GithubActionsRole to be able to write to the tfstate file
resource "aws_iam_role_policy" "github_role_dynamodb_policy" {
  name = "dynamodb_policy"
  role = aws_iam_role.GithubActionsRole.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { 
        Action = [
           "dynamodb:DescribeTable",
           "dynamodb:GetItem",
           "dynamodb:PutItem",
           "dynamodb:DeleteItem"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:::table/tf_lockid"
      },
    ]
  })
}

# Attach pre-existing AWS policies required for the github actions role
# This uses a for_each loop
resource "aws_iam_role_policy_attachment" "github_attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
  ])

  role       = aws_iam_role.GithubActionsRole.name
  policy_arn = each.value
}
