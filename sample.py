from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from tempfile import mkdtemp
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC

def handler(event=None, context=None):
    
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

    driver.get("https://www.google.com")
    
    title = driver.title
    driver.quit()
    return {
        "statusCode": 200,
        "body": f"{title}"
    }