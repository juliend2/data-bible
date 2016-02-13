# Codex Liberatus

Codex Liberatus est une application Web d'étude biblique, dont le code source
est Libre ([GPLv3](http://www.gnu.org/licenses/gpl-3.0.fr.html)).

## Dépendances

* Ruby >= 1.9.3
* Mac OS X ou Linux

## Installation

1. `git clone git@github.com:juliend2/codex-liberatus.git`
2. `cd codex-liberatus`
3. `bundle install`
4. `rake db:migrate`
5. `env JSON_PATH=./db/seed_data/louis-segond-formatted.json VERSION_SLUG=LSG rake db:seed`

## License

GPLv3
