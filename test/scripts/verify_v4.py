import asyncio
from playwright.async_api import async_playwright

async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        context = await browser.new_context(viewport={'width': 1280, 'height': 800})
        page = await context.new_page()

        page.on("console", lambda msg: print(f"BROWSER CONSOLE: {msg.type}: {msg.text}"))
        page.on("pageerror", lambda exc: print(f"BROWSER EXCEPTION: {exc}"))

        print("Navigating to http://localhost:3000...")
        try:
            await page.goto("http://localhost:3000", wait_until="networkidle", timeout=30000)
        except Exception as e:
            print(f"Navigation error: {e}")

        # Wait for Flutter to load and render
        await page.wait_for_timeout(15000)

        # 1. Home screen screenshot
        await page.screenshot(path="home_screen_v4.png")
        print("Captured home_screen_v4.png")

        await browser.close()

if __name__ == "__main__":
    asyncio.run(main())
