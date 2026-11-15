import { ReactNode } from 'react';
import { useT } from './get.transation.service.client';

interface TranslatedLabelProps {
  label: string;
  translationKey?: string;
  translationParams?: Record<string, string | number>;
  children?: ReactNode;
}

/**
 * Translation key derived from an English label ("Sign Up" -> "label_sign_up").
 * Used by TranslatedLabel and by option lists rendered with t().
 */
export const labelTranslationKey = (label: string) =>
  `label_${label.toLowerCase().replace(/\s+/g, '_').replace(/[^\w]/g, '')}`;

/**
 * TranslatedLabel is a wrapper component that translates labels in form components
 *
 * @param label - The original label text (fallback if no translation found)
 * @param translationKey - Optional custom translation key, defaults to normalized label text
 * @param translationParams - Optional parameters for translation interpolation
 * @param children - Optional children components
 */
export function TranslatedLabel({
  label,
  translationKey,
  translationParams = {},
  children,
}: TranslatedLabelProps) {
  const t = useT();

  // If no explicit key is provided, create one from the label
  const key = translationKey || labelTranslationKey(label);

  const translatedLabel = t(key, label, translationParams);

  return (
    <>
      {translatedLabel}
      {children}
    </>
  );
}
