module.exports = main:
  cwd: "./client/app"
  src: ['controllers'].map (d)-> "./#{d}/*"
  dest: "./require.coffee"

