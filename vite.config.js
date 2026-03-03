import { defineConfig } from "vite";

export default defineConfig({
  server: {
    proxy: {
      "/api/scoresaber": {
        target: "https://scoresaber.com",
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api\/scoresaber/, "/api"),
      },
    },
  },
});
