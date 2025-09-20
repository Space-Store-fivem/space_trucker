import React, { Fragment, useState, useEffect } from 'react';
import { Dialog, Transition } from '@headlessui/react';
import { useLocales } from '../../providers/LocaleProvider';
import { fetchNui } from '../../utils/fetchNui';
import { If, Then, Else } from 'react-if';
import { VisibilityType } from '../../utils/enum';
import { useIndustryData, useIndustryDataForSale, useIndustryDataWanted } from '../../state/industry';
import { useVisibilityState } from '../../state/visibility';
import { Tooltip } from 'react-tooltip';
import useSound from 'use-sound';

import clickSfx from '@assets/sounds/gtadecline.wav';
import navigateIcon from '@assets/images/icons/navigate-circle.svg';
import infoIcon from '@assets/images/icons/info.svg';
import { IndustryTradeData } from '../../types';

const IndustryInformation: React.FC<any> = ({ isIndustryInformationOpen, setIndustryInformationOpen }) => {
  const { locale } = useLocales();
  const industryData = useIndustryData();
  const industryDataForSale = useIndustryDataForSale();
  const industryDataWanted = useIndustryDataWanted();

  const [playClick] = useSound(clickSfx, { volume: 0.25 });

  function closeModal() {
    playClick();
    setIndustryInformationOpen(false);
  }

  const navigateToStorage = (storageName: string, tradeType: string) => {
    playClick();
    fetchNui('navigateIndustryStorage', {
      industryName: industryData.name,
      tradeType: tradeType,
      storageName: storageName,
    });
  };

  return (
    <>
      <Transition appear show={isIndustryInformationOpen} as={Fragment}>
        <Dialog as="div" className="relative z-10" onClose={closeModal}>
          <Transition.Child
            as={Fragment}
            enter="ease-out duration-300"
            enterFrom="opacity-0"
            enterTo="opacity-100"
            leave="ease-in duration-200"
            leaveFrom="opacity-100"
            leaveTo="opacity-0"
          >
            <div className="fixed inset-0 bg-purple bg-cover" />
          </Transition.Child>
          <div className="fixed inset-0 z-10 w-full">
            <div className="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
              <Transition.Child
                as={Fragment}
                enter="ease-out duration-300"
                enterFrom="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                enterTo="opacity-100 translate-y-0 sm:scale-100"
                leave="ease-in duration-200"
                leaveFrom="opacity-100 translate-y-0 sm:scale-100"
                leaveTo="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
              >
                <Dialog.Panel className="relative transform rounded-lg bg-sky text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-4xl">
                  <div className="bg-black/60 px-4 pb-4 pt-5 sm:p-6 sm:pb-4 rounded-tl-lg rounded-tr-lg">
                    <div className="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left">
                      <Dialog.Title as="h3" className="text-xl font-semibold leading-6 text-white text-center">
                        {locale.welcome} <span className="text-green-300">{industryData.label}</span>!
                      </Dialog.Title>
                      <div className="mt-2">
                        <p className="text-md text-gray-300 text-center">
                          {locale.industry_status_desc}{' '}
                          <span className="text-green-300">
                            {industryData.status === 0 ? locale.status_closed : locale.status_open}
                          </span>
                        </p>
                      </div>
                      <div className="mt-2">
                        <p className="text-md text-green-300">{locale.for_sale}</p>
                        <If condition={industryData.isBusiness}>
                          <Then>
                            <p className="text-sm text-gray-300">{locale.this_is_business_industry}</p>
                          </Then>
                          <Else>
                            <table className="text-md w-full text-left">
                              <thead className="text-gray-300">
                                <tr>
                                  <th scope="col" className="py-2 font-medium">
                                    {locale.commodity}
                                  </th>
                                  <th scope="col" className="px-6 py-2 font-medium">
                                    {locale.price}
                                  </th>
                                  <th scope="col" className="px-6 py-2 font-medium">
                                    {locale.production_per_hour}
                                  </th>
                                  <th scope="col" className="px-6 py-2 font-medium">
                                    {locale.in_stock_n_storage_size}
                                  </th>
                                  <th scope="col" className="px-6 py-2 font-medium">
                                    {/* {locale.navigate} */}
                                  </th>
                                </tr>
                              </thead>
                              <tbody>
                                {industryDataForSale.map((data: any, index) => {
                                  return (
                                    <>
                                      <tr key={index} className="text-white">
                                        <th scope="row" className="whitespace-nowrap py-1 font-normal flex">
                                          {data.label}
                                          <img
                                            data-tooltip-id="navigate-tooltip"
                                            data-tooltip-content={locale.you_can_sell_to + data.sellToInfo}
                                            className="cursor-pointer pl-2"
                                            src={infoIcon}
                                            width="25vw"
                                          />
                                        </th>
                                        <td className="px-6 py-1 font-normal">${data.price.toFixed(0)}</td>
                                        <td className="px-6 py-1 font-normal">{data.production}</td>
                                        <td className="px-6 py-1 font-normal">
                                          {data.inStock} {data.unit} ({data.storageSize})
                                        </td>
                                        <td className="absolute px-6 py-1">
                                          <img
                                            data-tooltip-id="navigate-tooltip"
                                            data-tooltip-content={locale.navigate}
                                            onClick={() => navigateToStorage(data.name, 'forsale')}
                                            className="cursor-pointer"
                                            src={navigateIcon}
                                            width="25vw"
                                          />
                                        </td>
                                      </tr>
                                    </>
                                  );
                                })}
                              </tbody>
                            </table>
                          </Else>
                        </If>
                      </div>
                      <div className="mt-2">
                        <p className="text-md text-green-300">{locale.wanted}</p>
                        <If condition={industryData.isPrimaryIndustry}>
                          <Then>
                            <p className="text-sm text-gray-300">{locale.this_is_primary_industry}</p>
                          </Then>
                          <Else>
                            <table className="text-md w-full text-left">
                              <thead className="text-gray-300">
                                <tr>
                                  <th scope="col" className="py-2 font-medium">
                                    {locale.commodity}
                                  </th>
                                  <th scope="col" className="px-6 py-2 font-medium">
                                    {locale.price}
                                  </th>
                                  <th scope="col" className="px-6 py-2 font-medium">
                                    {locale.consumption_per_hour}
                                  </th>
                                  <th scope="col" className="px-6 py-2 font-medium">
                                    {locale.in_stock_n_storage_size}
                                  </th>
                                  <th scope="col" className="px-6 py-2 font-medium">
                                    {/* {locale.navigate} */}
                                  </th>
                                </tr>
                              </thead>
                              <tbody>
                                {industryDataWanted.map((data: IndustryTradeData, index) => {
                                  return (
                                    <>
                                      <tr key={index} className="text-white">
                                        <th scope="row" className="whitespace-nowrap py-1 font-normal flex">
                                          {data.label}
                                          <img
                                            data-tooltip-id="navigate-tooltip"
                                            data-tooltip-content={locale.you_can_buy_from + data.buyFromInfo}
                                            className="cursor-pointer pl-2"
                                            src={infoIcon}
                                            width="25vw"
                                          />
                                        </th>
                                        <td className="px-6 py-1 font-normal">${data.price.toFixed(0)}</td>
                                        <td className="px-6 py-1 font-normal">{data.consumption}</td>
                                        <td className="px-6 py-1 font-normal">
                                          {data.inStock} {data.unit} ({data.storageSize})
                                        </td>
                                        <td className="absolute px-6 py-1">
                                          <img
                                            data-tooltip-id="navigate-tooltip"
                                            data-tooltip-content={locale.navigate}
                                            onClick={() => navigateToStorage(data.name, 'wanted')}
                                            className="cursor-pointer"
                                            src={navigateIcon}
                                            width="25vw"
                                          />
                                        </td>
                                      </tr>
                                    </>
                                  );
                                })}
                              </tbody>
                            </table>
                          </Else>
                        </If>
                      </div>
                      <Tooltip id="navigate-tooltip" opacity="1"/>
                    </div>
                  </div>
                  <div className="sm:px-auto bg-black/60 px-4 py-3 sm:flex sm:flex-row-reverse rounded-bl-lg rounded-br-lg">
                    <button
                      type="button"
                      className="text-md inline-flex w-full justify-center rounded-md bg-white px-3 py-2 font-bold text-gray-900 shadow-sm outline-none hover:bg-gray-200 sm:ml-3 sm:w-auto"
                      onClick={() => closeModal()}
                    >
                      {locale.exit.toUpperCase()}
                    </button>
                  </div>
                </Dialog.Panel>
              </Transition.Child>
            </div>
          </div>
        </Dialog>
      </Transition>
    </>
  );
};

export default IndustryInformation;
