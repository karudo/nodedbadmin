module.exports =
  htmlDist:
    files: [
      expand: yes
      flatten: yes
      cwd: "client/"
      src: ["index.html", "config/dist/environment.js"]
      dest: "public"
    ]
  htmlDebug:
    files: [
      expand: yes
      flatten: yes
      cwd: "client/"
      src: ["index.html", "config/debug/environment.js"]
      dest: "public"
    ]
  vendors:
    files: [
      {
        expand: yes
        flatten: yes
        cwd: "client/vendor/bower"
        src: ["jquery/dist/jquery.js", "handlebars/handlebars.js", "lodash/dist/lodash.js"]
        dest: "public"
      }
      {
        expand: yes
        cwd: "client/vendor"
        src: "emberqueryparams.js"
        dest: "public"
      }
      {
        expand: yes
        #flatten: yes
        cwd: "client/vendor/bower/bootstrap/dist/fonts"
        src: ["*"]
        dest: "public/fonts"
      }
    ]