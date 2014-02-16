module.exports = main:
  cwd: "./client/app"
  src: ['controllers', 'components', 'routes', 'classes'].map (d)-> "./#{d}/*"
  dest: "./require.coffee"

