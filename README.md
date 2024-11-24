## Badges  
/Users/vieerdubey/Desktop/ChromeInLambda/python/lib/python3.10/site-packages/sockshandler.py

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)  
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://choosealicense.com/licenses/gpl-3.0/)  
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](https://choosealicense.com/licenses/gpl-3.0/)


# 🚀 Run Headless Chrome in AWS Lambda! 🚀 

Welcome to the powerful world of automation! This guide will walk you through the steps to run Headless Chrome in AWS Lambda using the Selenium WebDriver and other dependencies. Follow along to see how easy it is to set up a Lambda function to perform web scraping or web testing at scale ⏱️.

## 🎯 Prerequisites

- **Nothing New**: We can start with our basic knowledge.
- **Terraform**: terraform installed on your local (only if you want to use automated way)

## 👨‍🔧 Using Terraform

- **Clone this reposistry** : this repo contains the terraform.tf
- **terraform will deploy** : a s3 bucket, and will push chrome.zip into that bucket then create layer , after that   lambda attached with those layer
- **screenshot**: the sample code pushes the screenshot in s3 if there is permission to lambda role

## 📦 Creating Chrome Layer for AWS Lambda

To run Chrome in AWS Lambda, you need to create a custom Lambda layer containing the necessary Chrome binaries and dependencies.

I have included all the necessary Chrome libraries, along with Chrome and Chromedriver, in the `chrome.zip` file.

## 🛠️ Creating Dependency Layer for AWS Lambda

1. **Clone this Repository**: 
    ```bash
    git clone https://github.com/vieer-code/ChromeInLambda.git
    ```

2. **Add your Dependencies**:
    ```bash
    python/lib/<python version you need>/site-packages/
    mkdir python/lib/python3.10/site-packages/
    cd python/lib/python3.10/site-packages/
    pip install selenium==4.22.0 --target ./
    zip folder python
    ```

3. **Upload to AWS Lambda Layers**:
    ```bash
    Navigate to aws Lambda layers
    if not able to upload cause of size limit , upload to s3 and then upload though s3
    ```


## 🛠️ Running lambda function

**Notes**: 
1. **Make sure the lambda memory size is atleast 500Mb**
2. **Make sure the lambda timeout is atleast 5Min, or more if code is long** 

**Sample Code**:
```python
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from tempfile import mkdtemp
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
import os
import boto3
import time

s3_client = boto3.client('s3')

def lambda_handler(event=None, context=None):
    
    chrome_service = Service("/opt/chromedriver")
    chrome_options = Options()
    chrome_options.binary_location = '/opt/headless-chromium'
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("--window-size=1280x1696")
    chrome_options.add_argument("--single-process")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--disable-dev-tools")
    chrome_options.add_argument("--no-zygote")
    chrome_options.add_argument(f"--user-data-dir={mkdtemp()}")
    chrome_options.add_argument(f"--data-path={mkdtemp()}")
    chrome_options.add_argument(f"--disk-cache-dir={mkdtemp()}")
    chrome_options.add_argument("--remote-debugging-port=9222")
    driver = webdriver.Chrome(service=chrome_service, options=chrome_options)

    driver.get("https://www.linkedin.com/in/vieerdwivedi/")
    time.sleep(2)
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, "body")))
    screenshot_path = "/tmp/screenshot.png"
    driver.save_screenshot(screenshot_path)
    s3_key = "screenshots/screenshot.png"
    try:
        with open(screenshot_path, "rb") as screenshot_file:
            s3_client.put_object(Bucket=os.environ.get('S3_BUCKET_NAME'), Key=s3_key, Body=screenshot_file)
    except:
        print("no permission to put into s3")
    title = driver.title
    driver.quit()
    return {
        "statusCode": 200,
        "body": f"{title}"
    }
```

## License  

[MIT](https://choosealicense.com/licenses/mit/)
