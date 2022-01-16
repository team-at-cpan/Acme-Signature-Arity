package Acme::Signature::Arity;

use strict;
use warnings;

use B;
use experimental qw(signatures);

use parent qw(Exporter);

=head1 NAME

Acme::Signature::Arity - provides reliable, production-ready signature introspection

=head1 DESCRIPTION

You'll know if you need this.

If you're just curious, perhaps start with L<https://www.nntp.perl.org/group/perl.perl5.porters/2021/11/msg262009.html>.

No part of this is expected to work in any way when given a sub that has a prototype.
There are other tools for those: L<Sub::Util>.

=cut

our @EXPORT_OK = qw(arity min_arity max_arity);
our @EXPORT = @EXPORT_OK;

=head1 Exported functions

=head2 arity

Returns the C<UNOP_aux> details for the first opcode for a coderef CV.
If that code uses signatures, this might give you some internal details
which mean something about the expected parameters.

Expected return information, as a list:

=over 4

=item * number of required scalar parameters

=item * number of optional scalar parameters (probably because there are defaults)

=item * a character representing the slurping behaviour, might be '@' or '%', or nothing (undef?) if it's
just a fixed list of scalar parameters

=back

This can also throw exceptions. That should only happen if you give it something that isn't
a coderef, or if internals change enough that the entirely-unjustified assumptions made by
this module are somehow no longer valid. Maybe they never were in the first place.

=cut

sub arity ($code) {
    die 'only works on coderefs' unless ref($code) eq 'CODE';
    my $cv = B::svref_2object($code);
    die 'probably not a coderef' unless $cv->isa('B::CV');
    my $next = $cv->START->next;
    # we pretend sub { } is sub (@) { }, for convenience
    return (0, 0, '@') unless $next and $next->isa('B::UNOP_AUX');
    return $next->aux_list($cv);
}

=head2 max_arity

Takes a coderef, returns a number or C<undef>.

If the code uses signatures, this tells you how many parameters you could
pass when calling before it complains - C<undef> means unlimited.

Should also work when there are no signatures, just gives C<undef> again.

=cut

sub max_arity ($code) {
    my ($minimum, $optional, $slurp) = arity($code);
    return undef if $slurp;
    return $minimum
}

=head2 min_arity

Takes a coderef, returns a number or C<undef>.

If the code uses signatures, this tells you how many parameters you need to
pass when calling - 0 means that no parameters are required.

Should also work when there are no signatures, returning 0 in that case.

=cut

sub min_arity ($code) {
    my ($minimum, $optional, $slurp) = arity($code);
    return $minimum - $optional;
}

1;

__END__

=head1 AUTHOR

C<< TEAM@cpan.org >>

=head1 WARRANTY

None, it's an Acme module, you shouldn't even be reading this.

