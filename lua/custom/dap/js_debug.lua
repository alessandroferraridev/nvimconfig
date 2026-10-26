-- Adapter DAP per JavaScript/TypeScript basato su vscode-js-debug.
--
-- Il bundle "js-debug-dap" viene scaricato al volo dalla pagina delle release
-- ufficiali di microsoft/vscode-js-debug (nessuna compilazione necessaria).
local M = {}

local API = 'https://api.github.com/repos/microsoft/vscode-js-debug/releases/latest'

local base = vim.fs.joinpath(vim.fn.stdpath 'data', 'dap', 'js-debug')
local server = vim.fs.joinpath(base, 'js-debug', 'src', 'dapDebugServer.js')
local version_file = vim.fs.joinpath(base, 'version.txt')

---@return boolean
function M.is_installed()
  return vim.fn.filereadable(server) == 1
end

---@return string?
function M.version()
  if vim.fn.filereadable(version_file) == 0 then
    return nil
  end
  return vim.trim(vim.fn.readfile(version_file)[1] or '')
end

local function curl(args)
  local cmd = {
    'curl',
    '-fsSL',
    '-H',
    'Accept: application/vnd.github+json',
    '-H',
    'User-Agent: neovim',
  }
  vim.list_extend(cmd, args)
  return vim.system(cmd):wait()
end

--- Scarica ed estrae l'ultima release di js-debug.
---@param callback fun(err: string?)
function M.install(callback)
  if M.is_installed() then
    return callback(nil)
  end

  if vim.fn.executable 'curl' ~= 1 then
    return callback "curl non e' installato: impossibile scaricare js-debug"
  end

  local info = curl { API }
  if info.code ~= 0 then
    return callback 'impossibile interrogare le release di vscode-js-debug'
  end

  local ok, release = pcall(vim.json.decode, info.stdout)
  if not ok or not release or not release.tag_name then
    return callback 'risposta non valida dalla API di GitHub'
  end

  local asset
  for _, a in ipairs(release.assets or {}) do
    if a.name and a.name:match '^js%-debug%-dap%-.*%.tar%.gz$' then
      asset = a
      break
    end
  end
  if not asset then
    return callback 'nessun asset js-debug-dap trovato nella release'
  end

  vim.fn.mkdir(base, 'p')
  local archive = vim.fs.joinpath(base, 'js-debug.tar.gz')
  local dl = curl { '-o', archive, asset.browser_download_url }
  if dl.code ~= 0 then
    return callback 'download di js-debug non riuscito'
  end

  local untar = vim.system({ 'tar', '-xzf', archive, '-C', base }):wait()
  vim.fn.delete(archive)
  if untar.code ~= 0 then
    return callback 'estrazione di js-debug non riuscita'
  end

  if not M.is_installed() then
    return callback "il bundle js-debug non e' stato estratto correttamente"
  end

  vim.fn.writefile({ release.tag_name }, version_file)
  vim.notify('js-debug ' .. release.tag_name .. ' installato', vim.log.levels.INFO)
  callback(nil)
end

--- Avvia il debug server e restituisce la porta su cui ascolta.
---@param callback fun(adapter: table)
---@param id string identificativo dell'adapter (es. 'pwa-node')
local function spawn_server(callback, id)
  local stdin = vim.uv.new_pipe(false)
  local stdout = vim.uv.new_pipe(false)
  local stderr = vim.uv.new_pipe(false)

  local handle, pid = vim.uv.spawn('node', {
    args = { server, '0', '127.0.0.1' },
    stdio = { stdin, stdout, stderr },
  }, function()
    stdin:close()
    stdout:close()
    stderr:close()
  end)

  if not handle then
    vim.notify('Impossibile avviare node: ' .. tostring(pid), vim.log.levels.ERROR)
    return
  end

  -- Il processo deve restare vivo: conserviamo il handle
  M._handle = handle

  local buffer = ''
  stdout:read_start(function(err, chunk)
    if err or not chunk then
      return
    end
    buffer = buffer .. chunk
    local port = buffer:match 'listening at [^:]*:(%d+)'
    if port then
      callback {
        type = 'server',
        host = '127.0.0.1',
        port = tonumber(port),
        id = id,
      }
    end
  end)

  stderr:read_start(function(err, chunk)
    if err or not chunk then
      return
    end
    vim.notify('js-debug: ' .. chunk, vim.log.levels.WARN)
  end)
end

--- Restituisce la funzione adapter per nvim-dap.
---@param id string
---@return fun(callback: fun(adapter: table))
function M.adapter(id)
  return function(callback)
    if M.is_installed() then
      return spawn_server(callback, id)
    end
    vim.notify('Download di js-debug in corso...', vim.log.levels.INFO)
    M.install(function(err)
      if err then
        vim.notify('js-debug: ' .. err, vim.log.levels.ERROR)
        return
      end
      spawn_server(callback, id)
    end)
  end
end

return M
