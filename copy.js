const fs = require('fs-extra');

fs.copy('./_site', './', e => {
    if (e) return console.error(e);
    console.log('copied _site to current dir');
});