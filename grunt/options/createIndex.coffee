module.exports = main:
  cwd: "./client/app"
  src: ['controllers', 'components', 'routes', 'classes', 'views'].map (d)-> "./#{d}/*"
  dest: "./require.coffee"

