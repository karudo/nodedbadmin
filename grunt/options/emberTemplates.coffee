module.exports =
  options:
    templateBasePath: /client\/app\/templates\//
    templateFileExtensions: /\.(hbs|hjs|handlebars)/

  debug:
    options:
      precompile: yes

    src: "client/app/**/*.{hbs,hjs,handlebars}"
    dest: "public/templates.js"

  dist:
    src: "<%= emberTemplates.debug.src %>"
    dest: "<%= emberTemplates.debug.dest %>"