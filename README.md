# Jekyll Aspec

[![Gem Version](https://badge.fury.io/rb/jekyll_aspec.svg)](https://badge.fury.io/rb/jekyll_aspec) [![Build Status](https://travis-ci.org/bsmith-n4/jekyll_aspec.svg?branch=master)](https://travis-ci.org/bsmith-n4/jekyll_aspec)

A selection of Asciidoctor extensions for use with Jekyll and [jekyll-asciidoc](https://github.com/asciidoctor/jekyll-asciidoc). 

These extensions add custom blocks for Requirements and attempts to smartly handle inter-document auto-linking functionality.

## Motivation

Jekyll is a very flexible and speedy tool for generating static HTML pages. 
The [jekyll-asciidoc](https://github.com/asciidoctor/jekyll-asciidoc) gem adds Asciidoctor functionality but it lacks a few features due to the way it handles multiple source files. As each `.adoc` file is consumed individually, we lose the ability to automatically format inter-document cross-references. This plugin is a group of extensions that performs some directory walking, stores the location of titles and anchors so that cross references in a Jekyll project are resolved automatically. 

Additional features are

* Custom block for ``TODO``s
* Requirements Block with versioning
* Requirements block macro that creates an appendix-style Table of Contents for Requirements
* Inline Callout macro to arbitrarily add callouts
* Inline Task macro to link to Jira tickets or Github Issues
* Inline Repo Macro to link to specific files or lines on GitHub
* A HTML postprocessor to correct some minor fixes and invalid tags created by Asciidoctor

When these custom extensions are combined with other recommended gems such as `asciidoctor-bibtex` and `asciidoctor-latex`, you can achieve quite high quality, speedy HTML documentation for technical projects with the benefits of a Jekyll build. It's recommended to use the [html-proofer](https://github.com/gjtorikian/html-proofer) gem which will validate all links created with these extensions.

## Installation

Add `jekyll_aspec` to your Jekyll Gemfile:

```ruby
group :jekyll_plugins do
  gem 'jekyll-asciidoc'
  gem 'jekyll_aspec'
end
```

Or install it yourself as:

```
$ gem install jekyll_aspec
```

## Docs

Yard documentation is generation automatically at [RubyDoc.info](http://www.rubydoc.info/gems/jekyll_aspec/)

Also refer to the `docs` directory for some basic documentation on extended Asciidoctor features.

## Contributing

This gem is under heavy initial development and there are still many kinks to work out. The areas to be improved upon include performance enhancements, proper handling of file IO / directory walking and, of course, documentation. Bug reports and pull requests are welcome on [GitHub](https://github.com/bsmith-n4/jekyll_aspec).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
