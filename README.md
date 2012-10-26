DerpKit is a scattered set of categories of functionality that should have been included in Apple's frameworks. It is meant to be unit-tested and have code that is fairly isolated, such that code in here could be extracted for other purposes. The guiding principle is that the code must be simple and widely applicable to be included.

Features
========

**Foundation:**

- Block-based KVO
- Percent-encoding on strings
- Base64-encoding on strings and data
- Generating random strings
- Generating HMAC-SHA1 signatures
- Moving UTF8 data between strings and data
- Block-based filtering and mapping on arrays and dictionaries

**UIKit:**

- View visibility control on view controllers
- Automatic view resizing based on keyboard presence

Usage
=====

The three ways to include DerpKit are:

- Include as a submodule and include as a static library
- Add to the project via [CocoaPods](http://cocoapods.org/)
- Pull individual files into your project

DerpKit is based on ARC.

Attribution
===========

DerpKit uses code from the following projects:

- [KVO+Blocks](https://gist.github.com/153676) by Andy Matuschak

License
=======

Copyright (c) 2012 Steve Streza

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
