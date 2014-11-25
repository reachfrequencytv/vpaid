var child_process = require('child_process')
  , VERSION = require(process.cwd() + '/package.json').version
  , SWF_ENV = process.env.npm_config_swf_env.toUpperCase()
  args = [
       './files/mxmlc/bin/mxmlc'
     , '-source-path+=./src/lib'
     , '-source-path+=./src/vendor'
     , '-allow-source-path-overlap=true'
     , '-static-link-runtime-shared-libraries=true'
     , '-target-player=10' // http://jacksondunstan.com/articles/1968
     , '-swf-version=14' // http://jacksondunstan.com/articles/1968
     , '-external-library-path=files/mxmlc/frameworks/libs/player/10.2/playerglobal.swc'
     , '-default-size 640 360'
     , '-default-background-color=0x' + ((process.env.npm_config_debug) ? '00FF00' : '000000')
     , './src/lib/tv/reachfrequency/VPAID.as'
     ,  '-o build/VPAID.swf'
  ]
;

console.log(args.join('\n=> '), '\n');
var mxmlc = child_process.exec(args.join(' '));
mxmlc.stdout.pipe(process.stdout);
mxmlc.stderr.pipe(process.stderr);
