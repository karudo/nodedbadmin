module.exports = app:
  options:
    bare: yes

  files: [
    expand: true
    cwd: "client/app/"
    src: "**/*.coffee"
    dest: "tmp/javascript/app"
    ext: ".js"
  ]