import asyncio
from playwright.async_api import async_playwright
import time

async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        context = await browser.new_context(viewport={'width': 1280, 'height': 800})
        page = await context.new_page()

        print("Navigating to http://localhost:3000...")
        try:
            await page.goto("http://localhost:3000", timeout=60000)
        except Exception as e:
            print(f"Navigation failed: {e}")
            await browser.close()
            return

        # Wait for Flutter to load
        print("Waiting for Flutter to load...")
        await page.wait_for_timeout(15000)

        # 1. Capture Home Screen
        await page.screenshot(path="verify_home.png")
        print("Captured verify_home.png")

        # 2. Click on 'Prière et culte' (Top Left category usually)
        # Approximate coordinates for the first card in a 2-column grid
        print("Clicking on 'Prière et culte'...")
        await page.mouse.click(320, 250)
        await page.wait_for_timeout(3000)
        await page.screenshot(path="verify_prayer_subcategories.png")

        # 3. Click on 'Ablution sèche (Tayammum)'
        # It should be the 3rd sub-category
        print("Clicking on 'Tayammum'...")
        await page.mouse.click(320, 600)
        await page.wait_for_timeout(3000)
        await page.screenshot(path="verify_tayammum_topics.png")

        # 4. Click on the first topic 'Conditions du Tayammum'
        print("Clicking on topic 'Conditions du Tayammum'...")
        await page.mouse.click(640, 100) # ListTile at top of TopicListScreen
        await page.wait_for_timeout(3000)
        await page.screenshot(path="verify_tayammum_detail.png")

        print("Verification screens captured.")
        await browser.close()

if __name__ == "__main__":
    asyncio.run(main())
