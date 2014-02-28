module.exports =
  ###
  appjs2public:
    files: [
      expand: yes
      cwd: "tmp"
      src: ["app.js"]
      dest: "public"
    ]
  ###
  htmlDist:
    files: [
      expand: yes
      flatten: yes
      cwd: "client/"
      src: ["index.html", "style.css", "config/dist/environment.js"]
      dest: "public"
    ]
  htmlDebug:
    files: [
      expand: yes
      flatten: yes
      cwd: "client/"
      src: ["index.html", "style.css", "config/debug/environment.js"]
      dest: "public"
    ]
  vendors:
    files: [
      {
        expand: yes
        flatten: yes
        cwd: "client/vendor/bower"
        src: ["ember/ember.js", "jquery/jquery.js", "handlebars/handlebars.js", "lodash/dist/lodash.js"]
        dest: "public"
      }
      {
        expand: yes
        cwd: "client/vendor"
        src: "ember140queryparams.js"
        dest: "public"
      }
      {
        expand: yes
        #flatten: yes
        cwd: "client/vendor/bower/bootstrap/dist"
        src: ["**/*"]
        dest: "public/bootstrap"
      }
    ]