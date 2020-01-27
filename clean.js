const del = require('del');

del.sync([
    './**',
    '!./.git',
    '!./src',
    '!./.eleventy.js',
    '!./.gitignore',
    '!./clean.js',
    '!./copy.js',
    '!./package.json',
    '!./yarn.lock',
    '!./node_modules'
]);