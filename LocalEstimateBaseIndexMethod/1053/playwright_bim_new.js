const { chromium } = require('playwright');
const path = require('path');

// Входной HTML (визуалка NEW)
const inputHtml = path.resolve('LocalEstimateBaseIndexMethod/БИМ_3.01_Пример 1 (2)_NEW.html');
const targetUrl = 'file:///' + inputHtml.replace(/\\/g, '/');

async function main() {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({
    viewport: { width: 1920, height: 1080 },
  });

  await page.goto(targetUrl);
  await page.screenshot({
    path: path.resolve('LocalEstimateBaseIndexMethod/1053/bim_3_01_new_playwright.png'),
    fullPage: true,
  });

  await browser.close();
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
