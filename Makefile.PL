use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME             => 'Mojolicious::Plugin::GraphQL',
  AUTHOR           => q{Ed J <etj@cpan.org>},
  VERSION_FROM     => 'lib/Mojolicious/Plugin/GraphQL.pm',
  ABSTRACT_FROM    => 'lib/Mojolicious/Plugin/GraphQL.pm',
  LICENSE          => 'artistic_2',
  MIN_PERL_VERSION => "5.006",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => '6.63_03',
  },
  "PREREQ_PM" => {
    "Mojolicious" => '8.00', # Mojo::Promise->resolve
    "strict" => 0,
    "warnings" => 0,
    "Module::Runtime" => 0,
    "GraphQL" => '0.39', # subscriptions
    "curry" => 0,
  },
  "TEST_REQUIRES" => {
    "Test::More" => "0.92",
  },
  META_MERGE => {
    "meta-spec" => { version => 2 },
    dynamic_config => 0,
    resources => {
      x_IRC => 'irc://irc.perl.org/#graphql-perl',
      repository => {
        type => 'git',
        url => 'git@github.com:graphql-perl/Mojolicious-Plugin-GraphQL.git',
        web => 'https://github.com/graphql-perl/Mojolicious-Plugin-GraphQL',
      },
      bugtracker  => {
        web => 'https://github.com/graphql-perl/Mojolicious-Plugin-GraphQL/issues',
      },
      license => [ 'http://dev.perl.org/licenses/' ],
    },
    prereqs => {
      develop => {
        requires => {
          'Test::Pod' => '1.22',
          'Pod::Markdown' => 0,
        },
      },
      runtime => {
        recommends => {
          'Cpanel::JSON::XS' => 0,
        },
      },
    },
  },
);

sub MY::postamble {
  my $container = 'graphqlperl/mojoliciousplugin';
  my $prereq = "$container-prereq";
  <<EOF;
pure_all :: README.md

README.md : \$(VERSION_FROM)
\tpod2markdown \$< >\$\@

containerprereq :
\tdocker build -f Dockerfile.prereq -t $prereq .

containerprereqpush :
\tdocker push $prereq

container :
\tdocker build -t $container .

containerpush :
\tdocker push $container
EOF
}
