import localFont from 'next/font/local';
import { thmanyahSans } from '@gitroom/frontend/fonts/thmanyah/thmanyah.font';

export const plusJakartaSans = localFont({
  src: [
    { path: './PlusJakartaSans.woff2', weight: '500 700', style: 'normal' },
    {
      path: './PlusJakartaSans-Italic.woff2',
      weight: '500 700',
      style: 'italic',
    },
  ],
  variable: '--font-jakarta',
});

/**
 * App font used by every layout: Thmanyah Sans for Arabic letters,
 * Plus Jakarta Sans for everything else (see `.font-app` in global.scss).
 * Kept under the old name so the layouts that use it stay unchanged.
 */
export const jakartaSans = {
  className: `${thmanyahSans.variable} ${plusJakartaSans.variable} font-app`,
};
