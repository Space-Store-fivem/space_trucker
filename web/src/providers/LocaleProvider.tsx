import { Context, createContext, useContext, useEffect, useState } from 'react';
import { useNuiEvent } from '../hooks/useNuiEvent';
import { debugData } from '../utils/debugData';
import { fetchNui } from '../utils/fetchNui';
import { isEnvBrowser } from '../utils/misc';
import type locale from '../../../locales/en.json';

type Locale = typeof locale.ui;

interface LocaleContextValue {
  locale: Locale;
  setLocale: (locales: Locale) => void;
}

debugData<Locale>([
  {
    action: 'setLocale',
    data: {
      welcome: 'Welcome to',
      industry_status_desc: 'The industry is currently',
      status_open: 'open',
      status_closed: 'closed',
      for_sale: 'For Sale',
      wanted: 'Wanted',
      commodity: 'Commodity',
      price: 'Price',
      production_per_hour: 'Production/Hour',
      consumption_per_hour: 'Consumption/Hour',
      in_stock_n_storage_size: 'In Stock (storage size)',
      proceed: 'Proceed',
      exit: 'Exit',
      this_is_primary_industry: 'This is a primary industry and does not need any resources.',
      this_is_business_industry: 'This is a business and does not sell resources.',
      confirm_buy: 'Confirm',
      unload: 'Unload',
      vehicle_storage: 'Vehicle Storage',
      vehicle_can_trans_type: 'Can transport goods type: ',
      item_amount: 'Amount: ',
      item_capacity_per_unit: 'Capacity per unit: ',
      item_by: 'By ',
      item_for: 'For ',
      vehicle_storage_is_empty: 'Vehicle storage is empty!',
      units: 'units',
      trucker_handbook: "TRUCKER'S HANDBOOK",
      truck_rental: 'TRUCK RENTAL',
      rank_courier_trainee: 'COURIER TRAINEE',
      rank_courier: 'COURIER',
      rank_pro_courier: 'PRO COURIER',
      rank_trucker_trainee: 'TRUCKER TRAINEE',
      rank_trucker: 'TRUCKER',
      rank_pro_trucker: 'PRO TRUCKER',
      total_profit: 'TOTAL PROFIT',
      total_package: 'TOTAL PACKAGE',
      total_distance: 'TOTAL DISTANCE',
      primary_industries: 'PRIMARY INDUSTRIES',
      secondary_industries: 'SECONDARY INDUSTRIES',
      businesses: 'BUSINESSES',
      vehicles_capacity: 'VEHICLES CAPACITY',
      primary_industry_desc:
        'Produce raw materials, such as wood log, meat and milk. They do not need any commodities to work and so they do not accept any cargo from truckers. However the truckers may buy commodities from these primary industries',
      secondary_industry_desc:
        'These industries require materials to produce goods! This means that truckers must sell primary commodities to secondary industries. Only then these industries will produce secondary commodities.',
      businesses_desc:
        'The end consumers of the supply chain. Products are consumed here and no resources are produced',
      vehicle_capacity_desc: 'List of vehicles that can transport goods and the level required to use them',
      truck_rental_locations: 'Truck Rental Locations',
      navigate: 'Navigate',
      location: 'location',
      locations: 'locations',
      you_are_here: 'You Are Here',
      cargo_in_hand: 'Cargo box in hand',
      toggle_confirm_dialog: 'Toggle confirm dialog when buy or sell',
      list: 'LIST',
      veh_rental: 'VEHICLE RENTAL',
      veh_capacity: 'VEHICLE CAPACITY',
      col_veh: 'VEHICLE',
      col_capacity: 'CAPACITY',
      col_trans_type: 'TRANSPORT TYPE',
      col_level: 'LEVEL REQUIRED',
      col_rent_price: 'RENT PRICE',
      rent_button: 'RENT',
      you_can_sell_to: 'You can sell to ',
      you_can_buy_from: 'You can buy from '
    },
  },
]);

const LocaleCtx = createContext<LocaleContextValue | null>(null);

const LocaleProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [locale, setLocale] = useState<Locale>({
    welcome: '',
    industry_status_desc: '',
    status_open: '',
    status_closed: '',
    for_sale: '',
    wanted: '',
    commodity: '',
    price: '',
    production_per_hour: '',
    consumption_per_hour: '',
    in_stock_n_storage_size: '',
    proceed: '',
    exit: '',
    this_is_primary_industry: '',
    this_is_business_industry: '',
    confirm_buy: '',
    unload: '',
    vehicle_storage: '',
    vehicle_can_trans_type: '',
    item_amount: '',
    item_capacity_per_unit: '',
    item_by: '',
    item_for: '',
    vehicle_storage_is_empty: '',
    units: '',
    trucker_handbook: '',
    truck_rental: '',
    rank_courier_trainee: '',
    rank_courier: '',
    rank_pro_courier: '',
    rank_trucker_trainee: '',
    rank_trucker: '',
    rank_pro_trucker: '',
    total_profit: '',
    total_package: '',
    total_distance: '',
    primary_industries: '',
    secondary_industries: '',
    businesses: '',
    vehicles_capacity: '',
    primary_industry_desc: '',
    secondary_industry_desc: '',
    businesses_desc: '',
    vehicle_capacity_desc: '',
    truck_rental_locations: '',
    navigate: '',
    location: '',
    locations: '',
    you_are_here: '',
    cargo_in_hand: '',
    toggle_confirm_dialog: '',
    list: '',
    veh_rental: '',
    veh_capacity: '',
    col_veh: '',
    col_capacity: '',
    col_trans_type: '',
    col_level: '',
    col_rent_price: '',
    rent_button: '',
    you_can_sell_to: '',
    you_can_buy_from: ''
  });

  useEffect(() => {
    if (!isEnvBrowser()) {
      fetchNui('loadLocale');
    }
  }, []);

  useNuiEvent('setLocale', async (data: Locale) => setLocale(data));

  return <LocaleCtx.Provider value={{ locale, setLocale }}>{children}</LocaleCtx.Provider>;
};

export default LocaleProvider;

export const useLocales = () => useContext<LocaleContextValue>(LocaleCtx as Context<LocaleContextValue>);
