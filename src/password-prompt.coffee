prompt = require 'prompt'
Q      = require 'q'
module.exports = (safeName) ->
  Q.Promise (resolve, reject) ->
    schema =
      properties:
        password:
          hidden: true
          required: true

    prompt.message = safeName
    prompt.get schema, (err, properties) ->
      return reject err if err
      resolve properties.password

