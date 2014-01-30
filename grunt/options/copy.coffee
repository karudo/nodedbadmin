module.exports =
  appjs2public:
    files: [
      expand: true
      cwd: "tmp"
      src: ["app.js"]
      dest: "public"
    ]
  html:
    files: [
      expand: true
      flatten: true
      cwd: "client/"
      src: ["config/environment.js", "index.html"]
      dest: "public"
    ]
  vendors:
    files: [
      expand: true
      flatten: true
      cwd: "client/vendor/bower"
      src: ["ember/ember.js", "jquery/jquery.js", "handlebars/handlebars.js", "lodash/dist/lodash.js"]
      dest: "public"
    ]