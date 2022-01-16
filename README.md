# NAME

Acme::Signature::Arity - provides reliable, production-ready signature introspection

# DESCRIPTION

You'll know if you need this.

If you're just curious, perhaps start with [https://www.nntp.perl.org/group/perl.perl5.porters/2021/11/msg262009.html](https://www.nntp.perl.org/group/perl.perl5.porters/2021/11/msg262009.html).

No part of this is expected to work in any way when given a sub that has a prototype.
There are other tools for those: [Sub::Util](https://metacpan.org/pod/Sub%3A%3AUtil).

For subs that don't have a prototype, this is _also_ not expected to work. It might help
demonstrate where to look if you wanted to write something proper, though.

# Exported functions

## arity

Returns the `UNOP_aux` details for the first opcode for a coderef CV.
If that code uses signatures, this might give you some internal details
which mean something about the expected parameters.

Expected return information, as a list:

- number of required scalar parameters
- number of optional scalar parameters (probably because there are defaults)
- a character representing the slurping behaviour, might be '@' or '%', or nothing (undef?) if it's
just a fixed list of scalar parameters

This can also throw exceptions. That should only happen if you give it something that isn't
a coderef, or if internals change enough that the entirely-unjustified assumptions made by
this module are somehow no longer valid. Maybe they never were in the first place.

## max\_arity

Takes a coderef, returns a number or `undef`.

If the code uses signatures, this tells you how many parameters you could
pass when calling before it complains - `undef` means unlimited.

Should also work when there are no signatures, just gives `undef` again.

## min\_arity

Takes a coderef, returns a number or `undef`.

If the code uses signatures, this tells you how many parameters you need to
pass when calling - 0 means that no parameters are required.

Should also work when there are no signatures, returning 0 in that case.

# AUTHOR

`TEAM@cpan.org`

# WARRANTY

None, it's an Acme module, you shouldn't even be reading this.
