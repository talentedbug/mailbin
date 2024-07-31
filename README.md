> The project was given up halfway. Sorry!

```
MAILBIN - A mailing list-style blog framework for static pages

MailBin is a blog framework that looks like a mailing list, aimed to bring 
your readers ease of reading, compatibility and light weight.

Main features:

- Minimal CSS: We've got no CSS files and the only lines are for displaying 
  monospace fonts.
- Pure HTML: Simple code leads to few requirements for browsers. Even Firefox 
  2 can load it correctly!
- Portability: Written in Bash script, MailBin can be used without pain on any 
  POSIX-compatible system.
- Traditional style: Lines are limited to 80 words per line strictly, which 
  *nix users are crazy about.

MailBin is meant to imitate mailing list, which is considered outdated by 
many. However, just like RSS, it is attractive for its feeling of simplicity. 
For an example you can read https://lkml.org/, the Linux Kernel Mailing List 
Archive.

MailBin use *plain* text as source files. It means no images, no extra files 
and no fancy text effects are allowed.

To install it on your system, simply clone this repository. Modify the 
settings according to your preference, which is not an optional step. Then run 
`bash mkmail.bash` to generate all the things.

For guides to configuration, please directly read comments in the code. It's 
detailed enough that you can customize anything available. Due to my laziness 
I created no Wiki pages for it, so please use the code instead.

If you'd like to deploy MailBin on a static page service, please upload the 
directory or choose it from a Git provider. Then set as following:

- "Build command" and so: "bash mkmail.bash"
- "Site root directory" and so: "site"

MailBin is licensed under the Unlicense. You are free to do anything to these 
code.
```
