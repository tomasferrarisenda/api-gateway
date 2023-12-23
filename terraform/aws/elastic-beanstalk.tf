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

