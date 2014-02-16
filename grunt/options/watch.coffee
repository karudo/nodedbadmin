module.exports =
  templates:
    files: ['client/app/**/*.{hbs,hjs,handlebars}']
    tasks: ['buildTemplates']

  scripts:
    files: ['client/app/**/*.{js,coffee}']
    tasks: ['buildScripts']
