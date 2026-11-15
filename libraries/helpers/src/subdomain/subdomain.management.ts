import { parse } from 'tldts';

export function getCookieUrlFromDomain(domain: string) {
  // allowPrivateDomains: hosts under shared suffixes on the Public Suffix
  // List (sslip.io, vercel.app, …) must not get a cookie for the suffix
  // itself (".sslip.io") — browsers reject it and login never sticks.
  const url = parse(domain, { allowPrivateDomains: true });
  return url.domain! ? '.' + url.domain! : url.hostname!;
}
