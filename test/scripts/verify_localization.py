import asyncio
from playwright.async_api import async_playwright

async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        context = await browser.new_context(viewport={'width': 1280, 'height': 800})
        page = await context.new_page()

        print("Navigating to http://localhost:3000...")
        await page.goto("http://localhost:3000")

        # Wait for Flutter to load
        await page.wait_for_timeout(10000)

        # 1. Capture French (Default)
        await page.screenshot(path="home_fr.png")
        print("Captured home_fr.png")

        # 2. Switch to Arabic
        print("Switching to Arabic...")
        await page.mouse.click(1160, 28) # Language icon (approximate, based on HomeScreen actions)
        await page.wait_for_timeout(1000)
        # In PopupMenu, Arabic is 3rd item
        await page.mouse.click(1160, 150) # Approximate click for Arabic in menu
        await page.wait_for_timeout(3000)
        await page.screenshot(path="home_ar.png")
        print("Captured home_ar.png")

        # 3. Switch to Russian
        print("Switching to Russian...")
        await page.mouse.click(1160, 28)
        await page.wait_for_timeout(1000)
        await page.mouse.click(1160, 200) # Approximate click for Russian
        await page.wait_for_timeout(3000)
        await page.screenshot(path="home_ru.png")
        print("Captured home_ru.png")

        # 4. Switch to Chinese
        print("Switching to Chinese...")
        await page.mouse.click(1160, 28)
        await page.wait_for_timeout(1000)
        await page.mouse.click(1160, 250) # Approximate click for Chinese
        await page.wait_for_timeout(3000)
        await page.screenshot(path="home_zh.png")
        print("Captured home_zh.png")

        # 5. Switch to English
        print("Switching to English...")
        await page.mouse.click(1160, 28)
        await page.wait_for_timeout(1000)
        await page.mouse.click(1160, 50) # Approximate click for English
        await page.wait_for_timeout(3000)
        await page.screenshot(path="home_en.png")
        print("Captured home_en.png")

        await browser.close()

if __name__ == "__main__":
    asyncio.run(main())
