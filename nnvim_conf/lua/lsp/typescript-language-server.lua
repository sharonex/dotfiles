return {
  cmd = { 'typescript-language-server' },
  -- Filetypes to automatically attach to.
  filetypes = { 'ts', 'typescript' },
  -- Sets the "root directory" to the parent directory of the file in the
  -- current buffer that contains either a ".luarc.json" or a
  -- ".luarc.jsonc" file. Files that share a root directory will reuse
  -- the connection to the same LSP server.
}
