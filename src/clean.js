// const rimraf = require('rimraf');
// const globby = require('globby');

// globby(['_site/**', '!_site/bear/', '!_site/teddy.txt'])
//     .then(paths => {
//         paths.map(item => {
//             rimraf.sync(item);
//         });
//     })
// ;

const del = require('del');

// del.sync([
//     '_site/**',
//     '!_site/bear',
//     '!_site/teddy.txt'
// ]);

// del.sync([
//     '../**',
//     '../.git',
//     '../src'
// ]);