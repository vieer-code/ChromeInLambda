## Badges  


[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)  
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://choosealicense.com/licenses/gpl-3.0/)  
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](https://choosealicense.com/licenses/gpl-3.0/)


chrome and chrome drive is in chrome layer

# Table of contents  
1. [Introduction](#introduction)  
2. [Prerequisites](#-prerequisites)
    1. [Sub paragraph](#subparagraph1)  
3. [Another paragraph](#paragraph2)  




# 🚀 Run Headless Chrome in AWS Lambda! 🚀 

Welcome to the powerful world of automation! This guide will walk you through the steps to run Headless Chrome in AWS Lambda using the Selenium WebDriver and other dependencies. Follow along to see how easy it is to set up a Lambda function to perform web scraping or web testing at scale ⏱️.

## 🎯 Prerequisites

Before we proceed, ensure you have the following:

- **AWS Account**: Ensure your AWS account is set up.
- **AWS CLI**: Make sure AWS CLI is installed and configured.
- **Python**: Ensure you're running Python 3.8 or later.
  
## 📦 Creating Chrome Layer for AWS Lambda

To run Chrome in AWS Lambda, you need to create a custom Lambda layer containing the necessary Chrome binaries and dependencies.

### Step 1: Prepare Chrome Layer

1. **Clone the Repository**: 
    ```bash
    git clone <your-chrome-layer-repo-url>
    cd chrome_layer
    ```

2. **Update Dependencies**:
    Check and update your dependencies as needed to ensure compatibility with Lambda's environment.

3. **Zip the Layer**:
    ```bash
    zip -r chrome_layer.zip .
    ```

4. **Upload to AWS Lambda**:
    ```bash
    aws lambda publish-layer-version --layer-name chrome_layer --zip-file fileb://chrome_layer.zip --compatible-runtimes python3.8
    ```

## 🛠️ Creating Dependency Layer for AWS Lambda

1. **Create a dependencies folder**:
   ```bash
   mkdir python
   cd python
   pip install selenium -t .
   cd ..# 🚀 Run Headless Chrome in AWS Lambda! 🚀

Welcome to the powerful world of automation! This guide will walk you through the steps to run Headless Chrome in AWS Lambda using the Selenium WebDriver and other dependencies. Follow along to see how easy it is to set up a Lambda function to perform web scraping or web testing at scale ⏱️.

## 🎯 Prerequisites

Before we proceed, ensure you have the following:

- **AWS Account**: Ensure your AWS account is set up.
- **AWS CLI**: Make sure AWS CLI is installed and configured.
- **Python**: Ensure you're running Python 3.8 or later.
  
## 📦 Creating Chrome Layer for AWS Lambda

To run Chrome in AWS Lambda, you need to create a custom Lambda layer containing the necessary Chrome binaries and dependencies.

### Step 1: Prepare Chrome Layer

1. **Clone the Repository**: 
    ```bash
    git clone <your-chrome-layer-repo-url>
    cd chrome_layer
    ```

2. **Update Dependencies**:
    Check and update your dependencies as needed to ensure compatibility with Lambda's environment.

3. **Zip the Layer**:
    ```bash
    zip -r chrome_layer.zip .
    ```

4. **Upload to AWS Lambda**:
    ```bash
    aws lambda publish-layer-version --layer-name chrome_layer --zip-file fileb://chrome_layer.zip --compatible-runtimes python3.8
    ```

## 🛠️ Creating Dependency Layer for AWS Lambda

1. **Create a dependencies folder**:
   ```bash
   mkdir python
   cd python
   pip install selenium -t .
   cd ..

## ⚙️ Configuring Your Lambda Function

### Step 1: Create a Lambda Function

1. **Navigate to AWS Lambda Console**: Go to the Amazon Lambda service page.
2. **Create Function**: Click on "Create Function" and choose "Author from scratch".
3. **Function Details**: Fill in the function name, runtime, and role.

### Step 2: Add Layers to the Function

1. **Go to Function's Layers Section**: In the lambda function, scroll down to the "Layers" section.
2. **Add Layers**: Click "Add a layer" and select your uploaded `chrome_layer` and `selenium_layer`.

### Step 3: Update Function Code

Update your Lambda function code to use Selenium with the headless Chrome browser.

**Sample Code**:
```python
import json
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

def lambda_handler(event, context):
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.binary_location = "/opt/chrome/chrome"
    
    driver = webdriver.Chrome("/opt/chromedriver", options=chrome_options)
    
    driver.get("https://www.example.com")
    page_title = driver.title
    driver.quit()
    
    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": f"Page title is: {page_title}"
        })
    }
```


## License  

[MIT](https://choosealicense.com/licenses/mit/)
