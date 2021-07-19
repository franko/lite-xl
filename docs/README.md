# Interface Files

This directory holds the documentation for the Lua C API that
is hidden in the C source files of Lite. The idea of these files
is to serve you as a quick reference about the functionality
that is not written in Lua it self. Please note that they
don't have any real code, just metadata or annotations.

Also, these interfaces are using
[EmmyLua annotation syntax](https://emmylua.github.io/annotation.html)
which is supported by LSP servers like the
[Sumneko Lua LSP](https://github.com/sumneko/lua-language-server).
This means that you can get nice code autocompletion and descriptions
of Lite core libraries and symbols when developing plugins or adding
any options to your **User Module File** (init.lua).

## The Base Core

Most of the code that is written in Lua for Lite is powered by the exposed
C API in the four namespaces that follow:

* [system](api/system.lua)
* [renderer](api/renderer.lua)
* [regex](api/regex.lua)
* [process](api/process.lua)

Finally, all global variables are documented in the file named
[globals.lua](api/globals.lua).
