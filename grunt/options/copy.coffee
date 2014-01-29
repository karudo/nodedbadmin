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
      cwd: "client/"
      src: ["enviroment.js", "index.html"]
      dest: "public"
    ]
  vendors:
    files: [
      expand: true
      flatten: true
      cwd: "client/vendor/bower"
      src: ["ember/ember.js", "jquery/jquery.js", "handlebars/handlebars.js"]
      dest: "public"
    ]