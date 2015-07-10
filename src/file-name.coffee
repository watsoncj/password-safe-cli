module.exports = (path) ->
  parts = path.trim().split('/')
  parts[parts.length - 1]
