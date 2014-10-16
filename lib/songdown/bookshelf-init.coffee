'use strict'

knexFunc = require 'knex'
bookshelfFunc = require 'bookshelf'

knex = knexFunc
    client: 'pg'
    connection: "what the heck?"

module.exports = bookshelfFunc knex
