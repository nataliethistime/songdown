'use strict'

knexFunc = require 'knex'
bookshelfFunc = require 'bookshelf'

knex = knexFunc
    client: 'mysql'
    connection:
        host: 'localhost'
        user: 'root'
        password: '123qwe'
        database: 'songdown_dev'
        #debug: yes

module.exports = bookshelfFunc knex
