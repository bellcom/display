#!/bin/sh
php bin/console app:screen-layouts:load --update --cleanup-regions https://raw.githubusercontent.com/os2display/display-templates/main/src/screen-layouts/full-screen.json
php bin/console app:screen-layouts:load --update --cleanup-regions https://raw.githubusercontent.com/os2display/display-templates/main/src/screen-layouts/three-boxes-horizontal.json
php bin/console app:screen-layouts:load --update --cleanup-regions https://raw.githubusercontent.com/os2display/display-templates/main/src/screen-layouts/three-boxes.json
php bin/console app:screen-layouts:load --update --cleanup-regions https://raw.githubusercontent.com/os2display/display-templates/main/src/screen-layouts/touch-template.json
php bin/console app:screen-layouts:load --update --cleanup-regions https://raw.githubusercontent.com/os2display/display-templates/main/src/screen-layouts/two-boxes.json
php bin/console app:screen-layouts:load --update --cleanup-regions https://raw.githubusercontent.com/os2display/display-templates/main/src/screen-layouts/two-boxes-vertical.json
php bin/console app:screen-layouts:load --update --cleanup-regions https://raw.githubusercontent.com/os2display/display-templates/main/src/screen-layouts/six-areas.json
php bin/console app:screen-layouts:load --update --cleanup-regions https://raw.githubusercontent.com/os2display/display-templates/main/src/screen-layouts/four-areas.json
