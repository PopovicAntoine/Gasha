# Role IAM
resource "aws_iam_role" "ec2_role" {
  name = "grand-role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Sid    = ""
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        }
      ]
    }
  )

}

# Policy EC2
resource "aws_iam_policy" "ec2_policy" {
  name        = "policy-ec2"
  path        = "/"
  description = "Policy to provide permission to EC2"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        Resource = "arn:aws:ssm:eu-west-3:2781-1922-3983:parameter/app-1*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:List*"
        ],
        "Resource" : [
          "arn:aws:s3:::skundu-proj3-3p-installers/download/*"
        ]
      }
    ]
  })

}




resource "aws_iam_role_policy_attachment" "custom" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "app1-ec2-profile"
  role = aws_iam_role.ec2_role.name

}