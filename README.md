
# REST server for basic user/group management

[![build status](https://api.travis-ci.org/vencax/node-basic-userman.svg)](https://travis-ci.org/vencax/node-basic-userman)

Is express pluggable.

## Install

	npm install basic-userman --save

## Configuration

Config is performed through few environment variables with obvious meaning:

- ADMINS_GID: group ID of admins
-	DATABASE_URL: connection string to DB
- SERVER_SECRET: random string (MUST be the same as login app part)
-	USE_CORS: set this to use CORS middleware

If you want to give a feedback, [raise an issue](https://github.com/vencax/node-basic-userman/issues).
