const http = require('http')
const fs = require('fs')
const path = require('path')

const sessionId = 'menu-first-add-double'
const outdir = path.resolve(process.cwd(), '.dbg')
const port = 7777
const host = '127.0.0.1'
const logFile = path.join(outdir, `trae-debug-log-${sessionId}.ndjson`)
const envFile = path.join(outdir, `${sessionId}.env`)

fs.mkdirSync(outdir, { recursive: true })
fs.writeFileSync(logFile, '')
fs.writeFileSync(envFile, `DEBUG_SERVER_URL=http://${host}:${port}/event\nDEBUG_SESSION_ID=${sessionId}\n`)

const server = http.createServer((req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS, GET')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type')

  if (req.method === 'OPTIONS') {
    res.statusCode = 204
    res.end()
    return
  }

  if (req.method === 'GET' && req.url === '/health') {
    res.setHeader('Content-Type', 'application/json')
    res.end(JSON.stringify({ ok: true, sessionId, logFile }))
    return
  }

  if (req.method === 'GET' && req.url.startsWith('/logs')) {
    res.setHeader('Content-Type', 'application/json')
    const content = fs.existsSync(logFile) ? fs.readFileSync(logFile, 'utf8') : ''
    const lines = content.split(/\r?\n/).filter(Boolean).map((line) => {
      try { return JSON.parse(line) } catch { return { raw: line } }
    })
    res.end(JSON.stringify(lines))
    return
  }

  if (req.method === 'POST' && req.url === '/event') {
    let body = ''
    req.on('data', (chunk) => { body += chunk })
    req.on('end', () => {
      try {
        const parsed = JSON.parse(body || '{}')
        if (!parsed.ts) parsed.ts = Date.now()
        fs.appendFileSync(logFile, `${JSON.stringify(parsed)}\n`)
        res.statusCode = 200
        res.end('ok')
      } catch (error) {
        res.statusCode = 400
        res.end(error.message)
      }
    })
    return
  }

  res.statusCode = 404
  res.end('not found')
})

server.listen(port, host, () => {
  process.stdout.write('@@DEBUG_SERVER_INFO\n')
  process.stdout.write(`${JSON.stringify({ api_url: `http://${host}:${port}/event`, session_id: sessionId, log_dir: outdir, log_file: logFile, env_file: envFile }, null, 2)}\n`)
  process.stdout.write('@@END_DEBUG_SERVER_INFO\n')
})
