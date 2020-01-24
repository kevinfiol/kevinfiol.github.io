const rimraf = require('rimraf');
rimraf('./_site/*', () => console.log('cleaned _site'));