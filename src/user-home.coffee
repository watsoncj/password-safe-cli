module.exports = process.env[if process.platform is 'win32' then 'USERPROFILE' else 'HOME']
