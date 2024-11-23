import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './playwright/tests-e2e',
  snapshotPathTemplate: './playwright/snapshots/{testFileName}/{arg}{ext}',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [ ['html', { open: 'never', outputFolder: './playwright/report' }] ],
  outputDir: './playwright/results',
  use: {
    baseURL: process.env.PROJECT_URL,
    trace: 'on-first-retry',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});

