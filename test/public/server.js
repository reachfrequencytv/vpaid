var http = require('http')
  , url = require('url')
  , fs = require('fs')
  , path = require('path')
  , PORT = 3000
;

http.createServer(function(req, res) {
  var filePath;
  res.setHeader('access-control-allow-origin', '*');
  if (req.url == '/')
    filePath = path.join(process.cwd(), 'test', 'public', 'index.html');
  else if (/VPAID\.swf/.test(req.url))
    filePath = path.join(process.cwd(), 'build', 'VPAID.swf');
  else
    filePath = path.join(process.cwd(), 'test', 'public', url.parse(req.url).pathname);
  fs.createReadStream(filePath)
    .on('error', function(err) { res.end(err.toString()) })
    .pipe(res);
}).listen(PORT);
console.log('vpaid test server listening on %s', PORT)
