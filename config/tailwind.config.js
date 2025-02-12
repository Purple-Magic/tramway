module.exports = {
  safelist: [
    'div-table',
    'div-table-row',
    'div-table-cell',
    'hidden',
    'text-xl',
    'text-4xl',
    'font-bold',
    'xl:hidden',
    'grid-cols-1',
    'grid-cols-2',
    'grid-cols-3',
    'grid-cols-4',
    'grid-cols-5',
    'grid-cols-6',
    'grid-cols-7',
    'grid-cols-8',
    'grid-cols-9',
    'grid-cols-10',
    'text-right',
    'w-2/3',
    'flex',
    'bg-purple-700',
    'px-6',
    'dark:placeholder-gray-400',
    'dark:text-white',
    'dark:bg-gray-800',
    'dark:bg-gray-900',
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
};
