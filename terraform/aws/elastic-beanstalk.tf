resource "aws_elastic_beanstalk_application" "myapp" {
  name        = "my-express-app"
  description = "My Express Application"
}

resource "aws_elastic_beanstalk_environment" "myenv" {
  name                = "my-express-app-env"
  application         = aws_elastic_beanstalk_application.myapp.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Node.js 14"  # Choose the relevant solution stack

  setting {
    namespace = "aws:elasticbeanstalk:container:nodejs"
    name      = "NodeCommand"
    value     = "npm start"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"  # Use 'LoadBalanced' for production
  }
}


resource "aws_elastic_beanstalk_environment" "myenv" {
  # ... other configuration ...

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "S3_BUCKET"
    value     = aws_s3_bucket.memes.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "S3_KEY"
    value     = "api.zip"
  }
}
