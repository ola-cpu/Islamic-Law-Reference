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

        # 1. Home screen screenshot (Checking new grid and media button)
        await page.screenshot(path="home_screen_v3.png")
        print("Captured home_screen_v3.png")

        # 2. Click Media Gallery button (Top right icon)
        # It's the first icon in actions. x=1280-48-48 (search is last, media is before it)
        # Search at x=1256, y=28. Media at x=1208, y=28.
        print("Clicking Media Gallery...")
        await page.mouse.click(1208, 28)
        await page.wait_for_timeout(3000)
        await page.screenshot(path="media_gallery.png")
        print("Captured media_gallery.png")

        # Go back to home
        await page.go_back()
        await page.wait_for_timeout(2000)

        # 3. Click first category (Prayer)
        print("Clicking category 'Prière'...")
        await page.mouse.click(320, 400)
        await page.wait_for_timeout(2000)

        # Click first topic (Lever les mains)
        print("Clicking topic 'Lever les mains'...")
        await page.mouse.click(640, 110)
        await page.wait_for_timeout(3000)
        await page.screenshot(path="detail_screen_v3.png")
        print("Captured detail_screen_v3.png")

        # Click comparison button
        # It's a ListTile in a Card. Should be below media section.
        # Try clicking around y=500
        print("Clicking comparison toggle...")
        await page.mouse.click(640, 500)
        await page.wait_for_timeout(2000)
        await page.screenshot(path="comparison_view.png")
        print("Captured comparison_view.png")

        await browser.close()

if __name__ == "__main__":
    asyncio.run(main())
