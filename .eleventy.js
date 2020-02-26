const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");
module.exports = function (eleventyConfig) {
    eleventyConfig.addPassthroughCopy("css");
    eleventyConfig.addPassthroughCopy("js");
    eleventyConfig.addPassthroughCopy("assets");
    eleventyConfig.addPassthroughCopy("_redirects");
    eleventyConfig.addPlugin(syntaxHighlight);
};