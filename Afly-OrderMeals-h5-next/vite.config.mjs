import { readFileSync } from 'node:fs'
import { fileURLToPath, URL } from 'node:url'
import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'

const fixtures = JSON.parse(readFileSync(new URL('./data.json', import.meta.url), 'utf8'))

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd())
  const target = env.VITE_H5_BACKEND_URL || 'http://192.168.2.17:8082'
  const proxy = {
    '/api/fr': { target, changeOrigin: true },
    '/clientSocket': { target, ws: true }
  }

  return {
    base: './',
    plugins: [
      vue(),
      {
        name: 'local-menu-fixtures',
        configureServer(server) {
          for (const name of ['seller', 'goods', 'ratings']) {
            server.middlewares.use('/api/' + name, (_request, response) => {
              response.setHeader('Content-Type', 'application/json')
              response.end(JSON.stringify({ errno: 0, data: fixtures[name] }))
            })
          }
        }
      }
    ],
    resolve: {
      alias: {
        api: fileURLToPath(new URL('./src/api', import.meta.url)),
        common: fileURLToPath(new URL('./src/common', import.meta.url)),
        components: fileURLToPath(new URL('./src/components', import.meta.url))
      }
    },
    server: { host: '0.0.0.0', port: 8080, proxy },
    preview: { proxy }
  }
})
