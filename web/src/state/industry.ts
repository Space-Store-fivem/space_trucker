import { atom, useAtomValue, useSetAtom, useAtom } from 'jotai';
import { IndustryData, IndustryTradeData } from '../types';

const industryData = atom<IndustryData>({
    name: '',
    label: '',
    status: 0,
    isPrimaryIndustry: false,
    isBusiness: false
});

export const useIndustryData = () => useAtomValue(industryData);
export const useSetIndustryData = () => useSetAtom(industryData);
export const useIndustryDataState = () => useAtom(industryData);

const industryDataForSale = atom<IndustryTradeData[]>([]);

export const useIndustryDataForSale = () => useAtomValue(industryDataForSale);
export const useSetIndustryDataForSale = () => useSetAtom(industryDataForSale);
export const useIndustryDataForSaleState = () => useAtom(industryDataForSale);

const industryDataWanted = atom<IndustryTradeData[]>([]);

export const useIndustryDataWanted = () => useAtomValue(industryDataWanted);
export const useSetIndustryDataWanted = () => useSetAtom(industryDataWanted);
export const useIndustryDataWantedState = () => useAtom(industryDataWanted);