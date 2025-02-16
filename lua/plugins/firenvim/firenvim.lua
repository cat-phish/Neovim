return {
  'glacambre/firenvim',
  -- build = ':call firenvim#install(0)', -- non-nixCats build
  build = require('nixCatsUtils').lazyAdd ':call firenvim#install(0)', -- nixCats build
}
