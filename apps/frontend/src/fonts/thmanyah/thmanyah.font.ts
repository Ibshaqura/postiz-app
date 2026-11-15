import localFont from 'next/font/local';

/**
 * Thmanyah Sans (خط ثمانية) for Arabic text only.
 *
 * LICENSE: the font files are NOT in this repository — the thmanyah font
 * license forbids redistributing or hosting them. Download the family from
 * https://thmanyah.com and copy the five `thmanyahsans-*.woff2` files into
 * this folder before building. They get compiled into the app bundle.
 *
 * `unicode-range` limits the face to Arabic code points, so Latin text keeps
 * Plus Jakarta Sans and the English UI looks exactly as before.
 */
export const thmanyahSans = localFont({
  src: [
    { path: './thmanyahsans-Light.woff2', weight: '300', style: 'normal' },
    { path: './thmanyahsans-Regular.woff2', weight: '400', style: 'normal' },
    { path: './thmanyahsans-Medium.woff2', weight: '500', style: 'normal' },
    { path: './thmanyahsans-Bold.woff2', weight: '700', style: 'normal' },
    { path: './thmanyahsans-Black.woff2', weight: '900', style: 'normal' },
  ],
  variable: '--font-thmanyah',
  display: 'swap',
  // no generated Arial fallback face: it has no unicode-range and would
  // otherwise catch Latin text before Plus Jakarta Sans
  adjustFontFallback: false,
  fallback: [],
  declarations: [
    {
      prop: 'unicode-range',
      value:
        'U+0600-06FF, U+0750-077F, U+0870-089F, U+08A0-08FF, U+FB50-FDFF, U+FE70-FEFF, U+200C-200F',
    },
  ],
});
