simple_transpiler
=================

An example of ruby2c transpiler, taking S-expressions parsed by Ripper as an input. 

Take note that simple_transpile supports VERY LIMITED set of ruby syntax. Feel free to folk and make your own transpiler starting from here.

## Usage

```ruby
require 'ripper'
require './smple_transpiler'

SimpleTranspiler.ruby2c(Ripper.sexp("a=1+1")) # a=1+1;

SimpleTranspiler.ruby2c(Ripper.sexp("printf \"hogehoge\" if i==2 and j%2")) # if (i==2&&j%2){printf("hogehoge");}
```

## License

[MIT](http://opensource.org/licenses/MIT)
