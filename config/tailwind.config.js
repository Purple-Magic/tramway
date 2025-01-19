const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  darkMode: 'class',
  content: [
    './public/*.html',
    './app/components/**/*.html.haml',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      screens: {
        ...defaultTheme.screens,
      },
    },
  },
  safelist: [
    'div-table',
    'div-table-row',
    'div-table-cell',
    'xl:hidden',
    'grid-cols-[1fr,1fr,1fr]',
    'text-right',
    // multiselect styles
    'absolute', 'shadow', 'top-100', 'z-40', 'w-full', 'lef-0', 'rounded', 'max-h-select', 'overflow-y-auto', 'cursor-pointer', 'rounded-t', 'border-b', 'hover:bg-teal-100', 'items-center', 'border-transparent', 'border-l-2,', 'relative', 'hover:border-teal-100', 'leading-6', 'bg-transparent', 'appearance-none', 'outline-none', 'h-full' , 'justify-center', 'm-1', 'font-medium', 'rounded-full', 'text-teal-700', 'bg-teal-100', 'border', 'border-teal-300', 'text-xs', 'font-normal', 'leading-none', 'max-w-full', 'flex-initial', 'flex-auto', 'flex-row-reverse',, 'flex-col', 'min-w-96', 'w-fit', 'flex-wrap', 'w-8', 'border-l',
    {
      pattern: /(text|bg|border)-(purple|blue|gray|yellow|red|white|green)-\d+/,
      variants: ['dark', 'focus', 'hover', 'dark:hover'],
    },
    {
      pattern: /(text|bg)-(purple|blue|gray|yellow|red|white)/,
      variants: ['dark', 'focus', 'hover', 'dark:hover'],
    },
    {
      pattern: /(m|p)(l|r|b|t|x|y)-\d+/
    },
  ],
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ],
};
