# ana06.github.io

Ana María Martínez Gómez ([@Ana06](https://github.com/Ana06)) personal page: <http://anamaria.martinezgomez.name>

It includes an _About me_ section, my cv and a blog.

This project also includes a resume in pdf: [resume-AnaMariaMartinez.pdf](resume-AnaMariaMartinez.pdf)


## Development

This site is built with [Jekyll](https://github.com/jekyll/jekyll) and [Bootstrap](https://github.com/twbs/bootstrap).

Just run `bundle exec jekyll serve`.

Or if you want to include future blog post (useful when working on unreleased blog post): `bundle exec jekyll serve --future`.

Remember that to use `bundle exec` you first need to run `bundle install` to install the required gems.


The [_posts](_posts) directory cointains all the blog post files. The [_data/cv.yml](_data/cv.yml) directory contains the CV information.


To get the cv in [`.pdf`](cv_latex/CV-AnaMariaMartinez.pdf) from the data in the [_data](_data) directory, inside the [cv_latex](cv_latex) directory run:

`ruby generate_cv.rb`

This will generate the [`.tex`](cv_latex/CV-AnaMariaMartinez.tex) and the [`.pdf`](cv_latex/CV-AnaMariaMartinez.pdf). This script is using `pdflatex`. Because of that, before using it, you need to install some packages. In openSUSE, you need `texlive-latex` and `texlive-fontawesome`.


### License and contributions

Except where otherwise noted, the content in this repository is licensed under a [Creative Commons Attribution 4.0 International License](LICENSE).
The code inside the [cv_latex](cv_latex) directory is licensed under [MIT](cv_latex/LICENSE).

List of used code/components:

- [Minima gem](https://github.com/jekyll/minima) (Jekyll default theme), lisenced under MIT,  was used as base.

- The header and the footer are based on the [Freelancer theme](https://startbootstrap.com/template-overviews/freelancer/), licensed under MIT.
The colors and the fonts of the whole app are also taken from there.

- The CV in [cv_latex](cv_latex) is based on the template from [Trey Hunner](http://www.treyhunner.com),
downloaded from <http://www.LaTeXTemplates.com> and licensed under Creative Commons CC BY 4.0.

- Favicon downloaded from <https://www.favicon-generator.org>.

