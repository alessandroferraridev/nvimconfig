-- Installazione di eclipse.jdt.ls (jdtls).
--
-- La versione pubblicata dal registro Mason richiede Java 25, quindi qui viene
-- usata una versione compatibile con Java 21, installata in
-- stdpath('data')/jdtls/<versione>.
local M = {}

M.version = '1.59.0'
M.archive = 'jdt-language-server-1.59.0-202605111959.tar.gz'
M.url = 'https://download.eclipse.org/jdtls/snapshots/' .. M.archive

local root = vim.fs.joinpath(vim.fn.stdpath 'data', 'jdtls')
local install_dir = vim.fs.joinpath(root, M.version)

---@return boolean
function M.installed()
  return vim.fn.isdirectory(vim.fs.joinpath(install_dir, 'plugins')) == 1
end

---@return string
function M.install_dir()
  return install_dir
end

local function notify(msg, level)
  vim.notify('jdtls: ' .. msg, level or vim.log.levels.INFO)
end

--- Scarica ed estrae jdtls (una tantum).
---@return boolean ok
function M.install()
  if M.installed() then
    return true
  end

  if vim.fn.executable 'curl' ~= 1 then
    notify("curl non e' installato: impossibile scaricare jdtls", vim.log.levels.ERROR)
    return false
  end

  vim.fn.mkdir(root, 'p')
  local archive = vim.fs.joinpath(root, M.archive)

  notify('download di jdtls ' .. M.version .. ' in corso...')
  local dl = vim.system({ 'curl', '-fsSL', '-o', archive, M.url }):wait()
  if dl.code ~= 0 then
    vim.fn.delete(archive)
    notify('download di jdtls non riuscito', vim.log.levels.ERROR)
    return false
  end

  local untar = vim.system({ 'tar', '-xzf', archive, '-C', root }):wait()
  vim.fn.delete(archive)
  if untar.code ~= 0 then
    notify('estrazione di jdtls non riuscita', vim.log.levels.ERROR)
    return false
  end

  if not M.installed() then
    notify("jdtls non e' stato estratto correttamente", vim.log.levels.ERROR)
    return false
  end

  notify('jdtls ' .. M.version .. ' installato')
  return true
end

--- Interprete Python necessario al launcher di eclipse.jdt.ls
---@return string?
local function python()
  for _, name in ipairs { 'python3', 'python' } do
    local path = vim.fn.exepath(name)
    if path ~= '' and path ~= nil then
      return path
    end
  end
  return nil
end

--- Comando per avviare jdtls.
---@return string[]?
function M.cmd()
  if not M.installed() then
    return nil
  end
  local py = python()
  if not py then
    notify('Python 3.9+ non trovato: impossibile avviare jdtls', vim.log.levels.ERROR)
    return nil
  end
  return { py, vim.fs.joinpath(install_dir, 'bin', 'jdtls') }
end

return M
