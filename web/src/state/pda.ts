import { atom, useAtomValue, useSetAtom, useAtom } from 'jotai';

import { TrukerData, PDAData, PDAIndustryData, VehicleCapacity, CarryData } from '../types';


const truckerData = atom<TrukerData>({
    totalProfit: 0,
    totalPackage: 0,
    totalDistance: 0,
    exp: 0,
    needExp: 0,
    level: 0,
});

const pdaData = atom<PDAData>({
    totalPrimary: 0,
    totalSecondary: 0,
    totalBusinesses: 0,
    totalVehicleCargo: 0
});

const industryList = atom<PDAIndustryData>({
    tier: 0,
    userCoord: {
        x: 0,
        y: 0
    },
    list: []
});

const vehicleList = atom<VehicleCapacity[]>([])

const carryData = atom<CarryData>({
    isCarry: false,
    itemName: '',
    buyPrice: 0,
    industryName: ''
})

export const useTruckerData = () => useAtomValue(truckerData);
export const useSetTruckerData = () => useSetAtom(truckerData);
export const useTruckerDataState = () => useAtom(truckerData);

export const usePDAData = () => useAtomValue(pdaData);
export const useSetPDAData = () => useSetAtom(pdaData);
export const usePDADataState = () => useAtom(pdaData);

export const useCarryData = () => useAtomValue(carryData);
export const useSetCarryData = () => useSetAtom(carryData);
export const useCarryDataState = () => useAtom(carryData);

export const useIndustryListData = () => useAtomValue(industryList);
export const useSetIndustryListData = () => useSetAtom(industryList);
export const useIndustryListDataState = () => useAtom(industryList);

export const useVehicleListData = () => useAtomValue(vehicleList);
export const useSetVehicleListData = () => useSetAtom(vehicleList);
export const useVehicleListDataState = () => useAtom(vehicleList);