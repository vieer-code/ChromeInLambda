module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.15.0"
  create_function = true
  create_role = true
  attach_policies = true
  policies = [ "arn:aws:iam::aws:policy/AmazonS3FullAccess" ]
  role_name = "Webscrapper-Lambda-chrome-selenium"
  function_name = "Webscrapper-Lambda-chrome-selenium"
  description   = "A Lambda-based web scraper that leverages any version of Selenium and Python, capable of launching Chrome to scrape data or automate any type of login process."
  handler       = "sample.lambda_handler"
  runtime       = "python3.10"
  create_layer = false
  source_path = "./sample.py"
  store_on_s3 = false
  architectures = [ "x86_64" ]
  memory_size = 500 # this is minimum 
  timeout = 300 # this is minimum 
  cloudwatch_logs_skip_destroy = false
  create_package = true
  layers = [ 
    module.chrome_layer.lambda_layer_arn,
    module.selenium_layer.lambda_layer_arn
   ]
  environment_variables = {
    S3_BUCKET_NAME = aws_s3_bucket.temp_s3.bucket
  }
}

module "chrome_layer" {
  source = "terraform-aws-modules/lambda/aws"
  version = "7.15.0"
  create_layer = true
  layer_name = "ChromeDependence"
  description = "This layer includes all the dependencies required for Chrome and Chromedriver, along with Chrome and Chromedriver binaries themselves."
  s3_bucket = aws_s3_bucket.temp_s3.bucket
  s3_prefix = "data/"
  s3_existing_package = {
    bucket = aws_s3_bucket.temp_s3.id
    key    = aws_s3_bucket_object.chrome_zip.key
  }
  create_package = false
  store_on_s3 = true
  package_type = "zip"
}


module "selenium_layer" {
  source = "terraform-aws-modules/lambda/aws"
  version = "7.15.0"
  create_layer = true
  create_package = false
  layer_name          = "SeleniumDependence"
  description         = "This layer contains dependence of selenium version 4.22, you can modify according to your need please check this video = "
  local_existing_package = "selenium.zip"
  package_type = "zip"
}
resource "aws_s3_bucket_object" "chrome_zip" {
  bucket = aws_s3_bucket.temp_s3.bucket
  key = "data/Chrome.zip"
  source = "Chrome.zip"
}
resource "aws_s3_bucket" "temp_s3" {
  bucket = "webscrapper-lambda-chrome-selenium-${formatdate("YYYY-MM-DD", timestamp())}"
  
}
