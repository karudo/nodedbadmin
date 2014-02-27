path = require 'path'
userHomeDir = process.env.HOME or process.env.HOMEPATH or process.env.USERPROFILE

module.exports =
  configPath: path.join userHomeDir,'./.config/nodedbadmin'
  logLevel: 'warn'
  webserverPort: 3000

