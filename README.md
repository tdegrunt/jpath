# JPath

JPath is a Ruby library that allows to execute XPath queries on JSON documents.

### Installation

JPath doesn't use any dependencies. Simply install via rubygems:

    gem install jpath

or clone it from github:

    git clone https://github.com/merimond/jpath.git

JPath is in early beta stage. So having an up-to-date Git version is more preferable.

## Library

Please note that JPath works with *standard* XPath syntax, not one of XPath alternatives, such as the great [JSONPath](http://goessner.net/articles/JsonPath/) syntax by Stefan Goessner. If you prefer the latter, there's a [terrific library](https://github.com/joshbuddy/jsonpath) by Joshua Hull that you should check out.

### A few caveats

Although JSON and XML are both data containers, they are quite different when it comes to searching and manipulating data. So JPath _may_ behave somewhat differently from what you woud expect, although we tried to make some sensible assumptions while transforming the XML-oriented search paradigm into the JSON world.

## Features

JPath support all the basic and some of the more advanced XPath functions:

Simple chains with children and ancestors:

    /store/book/author
    //author
    /store/*
    
Position predicates:

    //book[last()]
    //book[position()<3]

Attribute and child predicates:

    //book[@price<10]
    //book[isbn]

Multiple predicates:

    //book[@price>10][last()]

And all of the above in non-abbreviated form:

    /descendant::book
    /child::book[attribute::price="8.95"]

Test files are a bit of a mess at the moment, but they should give you an indication of what's currently supported.

## Contributing

Fork, send pull requests, file bug reports -- any help is welcome.