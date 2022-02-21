#!/usr/bin/env perl
#
# On-the-fly adjusting of the font size in urxvt
#
# Copyright (c) 2008 David O'Neill
#               2012 Noah K. Tilton <noahktilton@gmail.com>
#               2009-2012 Simon Lundström <simmel@soy.se>
#               2012-2016 Jan Larres <jan@majutsushi.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#
# URL: https://github.com/majutsushi/urxvt-font-size
#
# Based on:
# https://github.com/dave0/urxvt-font-size
# https://github.com/noah/urxvt-font
# https://github.com/simmel/urxvt-resize-font
#
# X11 fonts background:
# http://keithp.com/~keithp/talks/xtc2001/paper/

#:META:X_RESOURCE:%.step:interger:font size increase/decrease step

=head1 NAME

font-size - interactive font size setter

=head1 USAGE

Put the font-size script into $HOME/.urxvt/ext/ and add it to the list
of enabled perl-extensions in ~/.Xresources:

  URxvt.perl-ext-common: ...,font-size

The extension automatically binds Ctrl++ to the 'increase' function,
Ctrl+- to 'decrease', and Ctrl+0 to 'reset'. To use the other available functions
or change the keys, add some keybindings of your own:

  URxvt.keysym.C-Up:     font-size:increase
  URxvt.keysym.C-Down:   font-size:decrease
  URxvt.keysym.C-S-Up:   font-size:incglobal
  URxvt.keysym.C-S-Down: font-size:decglobal
  URxvt.keysym.C-equal:  font-size:reset
  URxvt.keysym.C-slash:  font-size:show

Note that for urxvt versions older than 9.21 the resources have to look like this:

  URxvt.keysym.C-Up:     perl:font-size:increase
  URxvt.keysym.C-Down:   perl:font-size:decrease
  URxvt.keysym.C-S-Up:   perl:font-size:incglobal
  URxvt.keysym.C-S-Down: perl:font-size:decglobal
  URxvt.keysym.C-equal:  perl:font-size:reset
  URxvt.keysym.C-slash:  perl:font-size:show

Supported functions:

=over 2

=item * increase/decrease:

      increase or decrease the font size of the current terminal.

=item * incglobal/decglobal:

      same as above and also adjust the X server values so all newly
      started terminals will use the same fontsize.

=item * incsave/decsave:

      same as incglobal/decglobal and also modify the ~/.Xresources
      file so the changed font sizes will persist over a restart of
      the X server or a reboot.

=item * reset:

      reset the font size to the value of the resource when starting
      the terminal.

=item * show

      show the current value of the 'font' resource in a popup.

=back

You can also change the step size that the script will use to increase
the font size:

  URxvt.font-size.step: 4

The default step size is 1. This means that with this setting a
size change sequence would be for example 8->12->16->20 instead of
8->9->10->11->12 etc. Please note that many X11 fonts are only
available in specific sizes, though, and odd sizes are often not
available, resulting in an effective step size of 2 instead of 1
in that case.
=cut

use strict;
use warnings;

my %escapecodes = (
    "font"           => 710,
    "boldFont"       => 711,
    "italicFont"     => 712,
    "boldItalicFont" => 713
);

sub on_init {
   my ($self) = @_;

   $self->bind_action ("C-plus", "%:increase")
      or warn "unable to register 'C-plus' as font-size increase hotkey\n";
   $self->bind_action ("C-minus", "%:decrease")
      or warn "unable to register 'C-minus' as font-size decrease hotkey\n";
   $self->bind_action ("C-0", "%:reset")
      or warn "unable to register 'C-0' as font-size reset hotkey\n";
}

sub on_start
{
    my ($self) = @_;

    $self->{step} = $self->x_resource("%.step") || 1;

    foreach my $type (qw(font boldFont italicFont boldItalicFont)) {
        $self->{$type} = $self->x_resource($type) || "undef";
    }
}

# Needed for backwards compatibility with < 9.21
sub on_user_command
{
    my ($self, $cmd) = @_;

    my $step = $self->{step};

    if ($cmd eq "font-size:increase") {
        fonts_change_size($self,  $step, 0);
    } elsif ($cmd eq "font-size:decrease") {
        fonts_change_size($self, -$step, 0);
    } elsif ($cmd eq "font-size:incglobal") {
        fonts_change_size($self,  $step, 1);
    } elsif ($cmd eq "font-size:decglobal") {
        fonts_change_size($self, -$step, 1);
    } elsif ($cmd eq "font-size:incsave") {
        fonts_change_size($self,  $step, 2);
    } elsif ($cmd eq "font-size:decsave") {
        fonts_change_size($self, -$step, 2);
    } elsif ($cmd eq "font-size:reset") {
        fonts_reset($self);
    } elsif ($cmd eq "font-size:show") {
        fonts_show($self);
    }
}

sub on_action
{
    my ($self, $action) = @_;

    my $step = $self->{step};

    if ($action eq "increase") {
        fonts_change_size($self,  $step, 0);
    } elsif ($action eq "decrease") {
        fonts_change_size($self, -$step, 0);
    } elsif ($action eq "incglobal") {
        fonts_change_size($self,  $step, 1);
    } elsif ($action eq "decglobal") {
        fonts_change_size($self, -$step, 1);
    } elsif ($action eq "incsave") {
        fonts_change_size($self,  $step, 2);
    } elsif ($action eq "decsave") {
        fonts_change_size($self, -$step, 2);
    } elsif ($action eq "reset") {
        fonts_reset($self);
    } elsif ($action eq "show") {
        fonts_show($self);
    }
}

sub fonts_change_size
{
    my ($term, $delta, $save) = @_;

    my @newfonts = ();

    my $curres = $term->resource('font');
    if (!$curres) {
        $term->scr_add_lines("\r\nWarning: No font configured, trying a default.\r\nPlease set a font with the 'URxvt.font' resource.");
        $curres = "fixed";
    }
    my @curfonts = split(/\s*,\s*/, $curres);

    my $basefont = shift(@curfonts);
    my ($newbasefont, $newbasedelta, $newbasesize) = handle_font($term, $basefont, $delta, 0, 0);
    push @newfonts, $newbasefont;

    # Only adjust other fonts if base font changed
    if ($newbasefont ne $basefont) {
        foreach my $font (@curfonts) {
            my ($newfont, $newdelta, $newsize) = handle_font($term, $font, $delta, $newbasedelta, $newbasesize);
            push @newfonts, $newfont;
        }
        my $newres = join(",", @newfonts);
        font_apply_new($term, $newres, "font", $save);

        handle_type($term, "boldFont",       $delta, $newbasedelta, $newbasesize, $save);
        handle_type($term, "italicFont",     $delta, $newbasedelta, $newbasesize, $save);
        handle_type($term, "boldItalicFont", $delta, $newbasedelta, $newbasesize, $save);
    }

    if ($save > 1) {
        # write the new values back to the file
        my $xresources = readlink $ENV{"HOME"} . "/.Xresources";
        system("xrdb -edit " . $xresources);
    }
}

sub fonts_reset
{
    my ($term) = @_;

    foreach my $type (qw(font boldFont italicFont boldItalicFont)) {
        my $initial = $term->{$type};
        if ($initial ne "undef") {
            font_apply_new($term, $initial, $type, 0);
        }
    }
}

sub fonts_show
{
    my ($term) = @_;

    my $out = $term->resource('font');
    $out =~ s/\s*,\s*/\n/g;

    $term->{'font-size'}{'overlay'} = {
        overlay => $term->overlay_simple(0, -1, $out),
        timer => urxvt::timer->new->start(urxvt::NOW + 5)->cb(
            sub {
                delete $term->{'font-size'}{'overlay'};
            }
        ),
    };
}

sub handle_type
{
    my ($term, $type, $delta, $basedelta, $basesize, $save) = @_;

    my $curres = $term->resource($type);
    if (!$curres) {
        return;
    }
    my @curfonts = split(/\s*,\s*/, $curres);
    my @newfonts = ();

    foreach my $font (@curfonts) {
        my ($newfont, $newdelta, $newsize) = handle_font($term, $font, $delta, $basedelta, $basesize);
        push @newfonts, $newfont;
    }

    my $newres = join(",", @newfonts);
    font_apply_new($term, $newres, $type, $save);
}

sub handle_font
{
    my ($term, $font, $delta, $basedelta, $basesize) = @_;

    my $newfont;
    my $newdelta;
    my $newsize;
    my $prefix = 0;

    if ($font =~ /^\s*x:/) {
        $font =~ s/^\s*x://;
        $prefix = 1;
    }
    if ($font =~ /^\s*(\[.*\])?xft:/) {
        ($newfont, $newdelta, $newsize) = font_change_size_xft($term, $font, $delta, $basedelta, $basesize);
    } elsif ($font =~ /^\s*-/) {
        ($newfont, $newdelta, $newsize) = font_change_size_xlfd($term, $font, $delta, $basedelta, $basesize);
    } else {
        # check whether the font is a valid alias and if yes resolve it to the
        # actual font
        my $lsfinfo = `xlsfonts -l $font 2>/dev/null`;

        if ($lsfinfo eq "") {
            # not a valid alias, ring the bell if it is the base font and just
            # return the current font
            if ($basesize == 0) {
                $term->scr_bell;
            }
            return ($font, $basedelta, $basesize);
        }

        my $fontinfo = (split(/\n/, $lsfinfo))[-1];
        my ($fontfull) = ($fontinfo =~ /\s+([-a-z0-9]+$)/);
        ($newfont, $newdelta, $newsize) = font_change_size_xlfd($term, $fontfull, $delta, $basedelta, $basesize);
    }

    # $term->scr_add_lines("\r\nNew font is $newfont\n");
    if ($prefix) {
        $newfont = "x:$newfont";
    }
    return ($newfont, $newdelta, $newsize);
}

sub font_change_size_xft
{
    my ($term, $fontstring, $delta, $basedelta, $basesize) = @_;

    my @pieces   = split(/:/, $fontstring);
    my @resized  = ();
    my $size     = 0;
    my $new_size = 0;

    foreach my $piece (@pieces) {
        if ($piece =~ /^(?:(?:pixel)?size=|[^=-]+-)(\d+(\.\d*)?)$/) {
            $size = $1;

            if ($basedelta != 0) {
                $new_size = $size + $basedelta;
            } else {
                $new_size = $size + $delta;
            }

            $piece =~ s/(=|-)$size/$1$new_size/;
        }
        push @resized, $piece;
    }

    my $resized_str = join(":", @resized);

    # don't make fonts too small
    if ($new_size >= 6) {
        return ($resized_str, $new_size - $size, $new_size);
    } else {
        if ($basesize == 0) {
            $term->scr_bell;
        }
        return ($fontstring, 0, $size);
    }
}

sub font_change_size_xlfd
{
    my ($term, $fontstring, $delta, $basedelta, $basesize) = @_;

    #-xos4-terminus-medium-r-normal-*-12-*-*-*-*-*-*-1

    my @fields = qw(foundry family weight slant setwidth style pixelSize pointSize Xresolution Yresolution spacing averageWidth registry encoding);

    my %font;
    $fontstring =~ s/^-//;  # Strip leading - before split
    @font{@fields} = split(/-/, $fontstring);

    if ($font{pixelSize} eq '*') {
        $term->scr_add_lines("\r\nWarning: Font size undefined, assuming 12.\r\nPlease set the 'URxvt.font' resource to a font with a concrete size.");
        $font{pixelSize} = '12'
    }
    if ($font{registry} eq '*') {
        $font{registry} ='iso8859';
    }

    # Blank out the size for the pattern
    my %pattern = %font;
    $pattern{foundry} = '*';
    $pattern{setwidth} = '*';
    $pattern{pixelSize} = '*';
    $pattern{pointSize} = '*';
    # if ($basesize != 0) {
    #     $pattern{Xresolution} = '*';
    #     $pattern{Yresolution} = '*';
    # }
    $pattern{averageWidth} = '*';
    # make sure there are no empty fields
    foreach my $field (@fields) {
        $pattern{$field} = '*' unless defined($pattern{$field});
    }
    my $new_fontstring = '-' . join('-', @pattern{@fields});

    my @candidates;
    # $term->scr_add_lines("\r\nPattern is $new_fontstring\n");
    open(FOO, "xlsfonts -fn '$new_fontstring' | sort -u |") or die $!;
    while (<FOO>) {
        chomp;
        s/^-//;  # Strip leading '-' before split
        my @fontdata = split(/-/, $_);

        push @candidates, [$fontdata[6], "-$_"];
        # $term->scr_add_lines("\r\npossibly $fontdata[6] $_\n");
    }
    close(FOO);

    if (!@candidates) {
        die "No possible fonts!";
    }

    if ($basesize != 0) {
        # sort by font size, descending
        @candidates = sort {$b->[0] <=> $a->[0]} @candidates;

        # font is not the base font, so find the largest font that is at most
        # as large as the base font. If the largest possible font is smaller
        # than the base font bail and hope that a 0-size font can be found at
        # the end of the function
        if ($candidates[0]->[0] > $basesize) {
            foreach my $candidate (@candidates) {
                if ($candidate->[0] <= $basesize) {
                    return ($candidate->[1], $candidate->[0] - $font{pixelSize}, $candidate->[0]);
                }
            }
        }
    } elsif ($delta > 0) {
        # sort by font size, ascending
        @candidates = sort {$a->[0] <=> $b->[0]} @candidates;

        foreach my $candidate (@candidates) {
            if ($candidate->[0] >= $font{pixelSize} + $delta) {
                return ($candidate->[1], $candidate->[0] - $font{pixelSize}, $candidate->[0]);
            }
        }
    } elsif ($delta < 0) {
        # sort by font size, descending
        @candidates = sort {$b->[0] <=> $a->[0]} @candidates;

        foreach my $candidate (@candidates) {
            if ($candidate->[0] <= $font{pixelSize} + $delta && $candidate->[0] != 0) {
                return ($candidate->[1], $candidate->[0] - $font{pixelSize}, $candidate->[0]);
            }
        }
    }

    # no fitting font available, check whether a 0-size font can be used to
    # fit the size of the base font
    @candidates = sort {$a->[0] <=> $b->[0]} @candidates;
    if ($basesize != 0 && $candidates[0]->[0] == 0) {
        return ($candidates[0]->[1], $basedelta, $basesize);
    } else {
        # if there is absolutely no smaller/larger font that can be used
        # return the current one, and beep if this is the base font
        if ($basesize == 0) {
            $term->scr_bell;
        }
        return ("-$fontstring", 0, $font{pixelSize});
    }
}

sub font_apply_new
{
    my ($term, $newfont, $type, $save) = @_;

    # $term->scr_add_lines("\r\nnew font is $newfont\n");

    $term->cmd_parse("\033]" . $escapecodes{$type} . ";" . $newfont . "\033\\");

    # load the xrdb db
    # system("xrdb -load " . X_RESOURCES);

    if ($save > 0) {
        # merge the new values
        open(XRDB_MERGE, "| xrdb -merge") || die "can't fork: $!";
        local $SIG{PIPE} = sub { die "xrdb pipe broken" };
        print XRDB_MERGE "URxvt." . $type . ": " . $newfont;
        close(XRDB_MERGE) || die "bad xrdb: $! $?";
    }
}
