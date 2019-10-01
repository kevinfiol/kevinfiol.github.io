const pug = require('pug');
const fs = require('fs');
const fse = require('fs-extra');
const marked = require('marked');
const path = require('path');

const SRC_PATH = path.join(__dirname, 'src/');
const DIST_PATH = path.join(__dirname, '/../');
const pugOptions = { pretty: true };

const write = (parentDir, filename, html) => {
    const dirPath = path.join(DIST_PATH, parentDir);
    const filePath = path.join(dirPath, filename);

    fs.mkdir(dirPath, { recursive: true }, e => {
        if (e) console.log('mkdir error:', e);
        
        fs.writeFile(filePath, html, e => {
            if (e) console.log('writeFile error:', e);
        });
    });
};

const copy = filename => {
    // const dirPath = path.join(DIST_PATH, parentDir);
    // const filePath = path.join(dirPath, filename);

    fse.copy(SRC_PATH + filename, DIST_PATH + filename)
        .then(() => console.log('Copied ' + filename))
    ;
};

// Home Page
const home = pug.compileFile(SRC_PATH + 'index.pug', pugOptions);
write('./', 'index.html', home({ title: 'kevin fiol' }));

// Demos Page
const demos = pug.compileFile(SRC_PATH + 'demos/index.pug', pugOptions);
write('demos/', 'index.html', demos({ title: 'demos' }));

// Resume Page
const resume = pug.compileFile(SRC_PATH + 'resume/index.pug', pugOptions);
fs.readFile(SRC_PATH + 'resume/resume.md', 'utf8', (e, contents) => {
    if (e) console.log(e);
    
    marked.setOptions({ breaks: true, sanitize: false });
    const resumeHtml = marked(contents);
    write('resume/', 'index.html', resume({ title: 'resume', resumeHtml }));
});

// Copy Static Assets
copy('CNAME');
copy('assets/');
copy('css/');