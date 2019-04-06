#!/usr/bin/env node
//DESC// Creates a Markdown modlist based on a modlist HTML file generated by the Twitch launcher.

const path = require('path');
const fs = require('fs');

const pattern = /<li><a href="(.+?)">([\w\d\s]+) \(by (.+?)\)<\/a><\/li>/;

function main(args) {
    if (args.length < 1) {
        console.error('Usage: modlist-creator <input file>');
        return;
    }

    const inputFile = path.resolve(args[0]);
    const data = fs.readFileSync(inputFile).toString();

    const mods = data.split('\n')
        .map(line => line.match(pattern))
        .filter(match => !!match)
        .map(match => ({
            name: match[2],
            url: match[1],
            author: match[3]
        }))
        .sort((a, b) => a.name.localeCompare(b.name));

    const output = mods.map(mod => `## [${mod.name}](${mod.url})\n**Author:** _${mod.author}_`).join('\n\n');

    console.log(output);
}

main(process.argv.slice(2));
