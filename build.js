const pug = require('pug');
const fs = require('fs');
const marked = require('marked');

const SRC_PATH = './src/';
const DIST_PATH = './dist/';
const pugOptions = { pretty: true };

const write = (path, html) => {
    fs.writeFile(DIST_PATH + path, html, e => {
        if (e) console.log(e);
    });
};

// Home Page
const home = pug.compileFile('./src/index.pug', pugOptions);
write('index.html', home({ title: 'Kevin Fiol' }));

// Resume Page
const resume = pug.compileFile('./src/resume/index.pug', pugOptions);
fs.readFile('./src/resume/resume.md', 'utf8', (e, contents) => {
    if (e) console.log(e);
    
    marked.setOptions({ breaks: true, sanitize: false });
    const resumeHtml = marked(contents);
    write('resume/index.html', resume({ title: 'Resume - Kevin Fiol', resumeHtml }));
});