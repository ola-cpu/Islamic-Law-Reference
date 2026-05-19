import asyncio
from playwright.async_api import async_playwright

async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        context = await browser.new_context(viewport={'width': 800, 'height': 600})
        page = await context.new_page()

        print("Navigating to http://localhost:3000...")
        await page.goto("http://localhost:3000")
        await page.wait_for_timeout(15000)

        # 1. Capture French (Default)
        await page.screenshot(path="home_fr_s.png", scale="css")
        print("Captured home_fr_s.png")

        # 2. Switch to Arabic
        print("Switching to Arabic...")
        await page.mouse.click(720, 28) # Adjusted for 800 width
        await page.wait_for_timeout(1000)
        await page.mouse.click(720, 150)
        await page.wait_for_timeout(5000)
        await page.screenshot(path="home_ar_s.png", scale="css")
        print("Captured home_ar_s.png")

        await browser.close()

if __name__ == "__main__":
    asyncio.run(main())
