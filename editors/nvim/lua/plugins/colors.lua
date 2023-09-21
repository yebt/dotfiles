return {
  {
    'loctvl842/monokai-pro.nvim',
    config = require('plugins.config.monokai-pro'),
  },
  {
    'https://github.com/catppuccin/nvim',
    config = require('plugins.config.catppuccin'),
  },
  {
    'rebelot/kanagawa.nvim',
    config = require('plugins.config.kanagawa'),
  },
  {
    'xero/miasma.nvim',
    config = require('plugins.config.miasma'),
  },
  {
    '2nthony/vitesse.nvim',
    dependencies = {
      'tjdevries/colorbuddy.nvim',
    },
    config = require('plugins.config.vitesse'),
  },
  {
    'projekt0n/github-nvim-theme',
    config = require('plugins.config.github-nvim-theme'),
  },
}
