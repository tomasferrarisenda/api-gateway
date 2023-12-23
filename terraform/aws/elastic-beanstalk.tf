resource "aws_iam_role" "eb_role" {
  name = "my-eb-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eb_role_policy" {
  role       = aws_iam_role.eb_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkReadOnly"  # Updated policy ARN
}


resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "my-eb-instance-profile"
  role = aws_iam_role.eb_role.name
}



resource "aws_elastic_beanstalk_application" "myapp" {
  name        = "my-express-app"
  description = "My Express Application"
}

resource "aws_elastic_beanstalk_environment" "myenv" {
  name                = "my-express-app-env"
  application         = aws_elastic_beanstalk_application.myapp.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.0.4 running Node.js 18"  # Choose the relevant solution stack

#   setting {
#     namespace = "aws:elasticbeanstalk:container:nodejs"
#     name      = "NodeCommand"
#     value     = "npm start"
#   }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"  # Use 'LoadBalanced' for production
  }

setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "S3_BUCKET"
    value     = aws_s3_bucket.memes.id
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "S3_KEY"
    value     = "api.zip"
  }
}

