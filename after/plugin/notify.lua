--minimal notifications config
require('notify').setup({
  stages = 'fade',
  timeout = 1000, 
  max_height = 5,
  max_width = 70,
  background_colour = 'NotifyBackground',
  render = 'minimal',
})
