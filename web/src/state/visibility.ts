import { atom, useAtom, useAtomValue, useSetAtom } from 'jotai';

const visibilityAtom = atom(-1);
const pdaVisibilityAtom = atom(0);

export const useVisibilityValue = () => useAtomValue(visibilityAtom);
export const useSetVisibility = () => useSetAtom(visibilityAtom);
export const useVisibilityState = () => useAtom(visibilityAtom);


export const usePDAVisibilityValue = () => useAtomValue(pdaVisibilityAtom);
export const useSetPDAVisibility = () => useSetAtom(pdaVisibilityAtom);
export const usePDAVisibilityState = () => useAtom(pdaVisibilityAtom);

