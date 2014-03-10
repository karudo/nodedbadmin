module.exports =
  templates:
    files: ['client/app/**/*.{hbs,hjs,handlebars}']
    tasks: ['buildTemplates']

  scripts:
    files: ['client/app/**/*.{js,coffee}']
    tasks: ['buildScripts']

  static:
    files: ['client/*.{css,html}']
    tasks: ['copy:html']

  less:
    files: ['client/app/styles/*.less']
    tasks: ['less']
