exclude = [
  '!**/.DS_Store'
  '!**/Thumbs.db'
  '!**/*.coffee'
  '!**/*.map'
  '!**/*.scss'
  '!**/scss/*'
  '!**/*.less'
  '!**/less/*'
  '!**/css.compile/*'
  '!**/*.s.css'
  '!**/*.l.css'
  '!**/<%= dir.cssCompile %>/'
  '!**/coffee/'
  '!**/sass/'
  '!**/less/'
  '!**/_notes/'
  '!**/.idea/'
  '!**/.gitignore'
  '!**/*.mno'
  '!**/Templates/'
  '!**/Library'
  '!**/*.dwt'
  '!**/*.lbi'
  '!**/*.fla'
]
 
module.exports = (grunt) ->
  pkg = grunt.file.readJSON 'package.json'
  grunt.initConfig
    # Directory setting
    dir :
      # src : '../src'
      src : '../'
      dist : '../dist'
      doc : '../docs'
      js : 'public/javascripts'
      coffee : '_coffee'
      css : 'public/stylesheets'
      cssCompile : '<%= dir.src %>/_css.compile'
    # package.json file loading
    pkg : pkg
    # clean
    clean:
      js:
        src : '<%= dir.src %>/<%= dir.js %>/*'
      css:
        src : '<%= dir.src %>/<%= dir.css %>/*'
      build :
        src : ['<%= dir.dist %>/**', '<%= dir.doc %>/**']
    # CoffeeScript compile
    coffee:
      options:
        sourceMap : true
      # Main Directory coffeeScript File Compile
      main :
        expand: true
        cwd: '<%= dir.src %>/<%= dir.coffee %>/'
        src : ['*.coffee']
        dest : '<%= dir.src %>/<%= dir.js %>/'
        ext: '.js'
      # coffeeScript File all Compile
      all :
        expand : true
        ext : '.js'
        src : ['<%= dir.src %>/**/*.coffee',
              '<%= dir.src %>/**/**/*.coffee']
    compass:
      # Main Directory SASS File Compile
      main :
        expand: true
        ext : '.css'
        src : ['<%= dir.src %>/_sass/*.scss']
        options :
          config : 'config.rb'
          environment: 'production'
          force: true
      # SASS File all Compile
      # all :
      #  expand : true
      #  ext : '.css'
      #  src : ['<%= dir.src %>/**/*.scss',
      #        '<%= dir.src %>/**/**/*.scss',]
      #  options :
      #    config : 'config.rb'
      #    environment: 'production'
      #    force: true
    # File Concat
    concat:
      # Compiled CSS file concat
      css :
        src : '<%= dir.cssCompile %>/*.css'
        dest : '<%= dir.src %>/<%= dir.css %>/style.css'
        # dest : '<%= dir.src %>/<%= dir.css %>/<%= pkg.name %>.css'
    # Image File Optimization
    imagemin:
      dev :
        optimizationLevel: 3
        files : [
          expand: true
          src: '<%= dir.src %>/**/*.{png,jpg,jpeg}'
        ]
      dist :
        optimizationLevel: 3
        files : [
          expand: true
          src: '<%= dir.dist %>/**/*.{png,jpg,jpeg}'
        ]
    # File watching
    watch:
      coffee:
        files : '<%= dir.src %>/<%= dir.coffee %>/*.coffee'
        tasks : 'coffee:main'
      # coffeeAll:
      #   files : '<%= coffee.all.src %>'
      #   tasks : 'coffee:all'
      compass:
        files : '<%= compass.main.src %>'
        tasks : 'compass:main'
      # compassAll:
      #   files : '<%= compass.all.src %>'
      #   tasks : 'compass:all'
      css:
        files : '<%= concat.css.src %>'
        tasks : 'concat:css'
    # copy
    copy:
      build :
        expand : true
        filter: 'isFile'
        cwd : '<%= dir.src %>/'
        src : ['**'].concat exclude
        dest : '<%= dir.dist %>/'
    # html minify
    htmlmin:
      all :
        options :
          removeComments : true
          removeCommentsFromCDATA : true
          removeCDATASectionsFromCDATA : true
          collapseWhitespace : true
          removeRedundantAttributes : true
          removeOptionalTags : true
        expand : true
        src : '<%= dir.dist %>/**/*.html'
    # JS minify
    uglify:
      options :
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("dd-mm-yyyy") %> */\n'
      main :
        expand : true
        src : '<%= dir.dist %>/<%= dir.js %>/<%= pkg.name %>.js'
      all :
        expand : true
        src : ['<%= dir.dist %>/**/*.js', '!<%= uglify.main.src %>']
    # CSS minify
    cssmin:
      main :
        expand : true
        src : '<$= dir.dist %>/<%= dir.css %>/<%= pkg.name %>.css'
      all :
        expand : true
        src : ['<%= dir.dist %>/**/*.css', '!<%= cssmin.main.src %>']
    # yuidoc
    yuidoc:
      dist:
        name : '<%= pkg.name %>'
        description : '<%= pkg.description %>'
        version : '<%= pkg.version %>'
      options :
        paths : '<%= dir.src %>/'
        outdir : '<%= dir.doc %>'
        syntaxtype : 'coffee'
        extension : '.coffee'
    # Style Guide
    styledocco:
      dist: 
        options:
          name: '<%= pkg.name %>'
          preprocessor: 'scss --compass'
        files:
          '<%= dir.doc %>/styleguide': ['<%= dir.src %>/_sass/*.scss']
 
  for taskName of pkg.devDependencies when taskName.substring(0, 6) is 'grunt-'
    grunt.loadNpmTasks taskName
 
  # Ailas
  grunt.registerTask 'default', 'watch'
  grunt.registerTask 'w', 'watch'
  grunt.registerTask 'c', ['clean:js', 'clean:css']
  grunt.registerTask 'main', ['coffee:main', 'compass:main']
  grunt.registerTask 'compile', ['coffee:all', 'compass:all']
  grunt.registerTask 'img', 'imagemin:dev'
  grunt.registerTask 'build', ['clean:build', 'copy', 'imagemin:dist', 'htmlmin', 'uglify', 'cssmin', 'yuidoc', 'styleguide', 'styledocco']