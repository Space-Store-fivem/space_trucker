import React, { Fragment, useState, useEffect } from 'react';
import { useLocales } from '../../providers/LocaleProvider';
import { usePDAVisibilityState, useVisibilityState } from '../../state/visibility';
import tw from 'tailwind-styled-components';
import useSound from 'use-sound';
import { fetchNui } from '../../utils/fetchNui';
import clickSfx from '@assets/sounds/gtaselect.mp3';
import profitIcon from '@assets/images/icons/profit.svg';
import deliveryIcon from '@assets/images/icons/delivery.svg';
import distanceIcon from '@assets/images/icons/distance.svg';
import { usePDAData, useSetIndustryListData, useTruckerData, useVehicleListDataState } from '../../state/pda';

import { CircularProgressbar } from 'react-circular-progressbar';
import 'react-circular-progressbar/dist/styles.css';
import { IndustryTier, PDAVisibilityType } from '../../utils/enum';
import { getRankImage, getRankLabel } from '../../utils/misc';

const PDAStatics: React.FC = () => {
  const { locale } = useLocales();
  const [pdaVisible, setPDAVisible] = usePDAVisibilityState();
  const [vehicleList, setVehicleList] = useVehicleListDataState();
  const setIndustryListData = useSetIndustryListData();
  const [playClick] = useSound(clickSfx, { volume: 0.25 });

  const truckerData = useTruckerData();
  const pdaData = usePDAData();

  //PDA Select Industry
  const selectIndustryTier = async (industryTier: number) => {
    playClick();
    const industries = await fetchNui(
      'loadIndustryList',
      { industryTier: industryTier },
      {
        tier: industryTier,
        userCoord: {
          x: 0,
          y: 0,
        },
        list: [
          {
            typeId: 1,
            title: 'Oil field', //Industry Type Name
            locations: [
              {
                id: 'murieta_oilfield',
                title: 'Murieta Oilfield',
                x: 1535.7732,
                y: -2098.0173,
              },
            ],
          },
          {
            typeId: 2,
            title: 'Scrap Yard', //Industry Type Name
            locations: [
              {
                id: 'roger_scapyard',
                title: "Roger's Scrap Yard",
                x: -428.9064,
                y: -1728.5099,
              },
              {
                id: 'thomson_scrapyard',
                title: "Thomson's Scrap Yard",
                x: 2392.1606,
                y: 3121.2771,
              },
            ],
          },
          {
            typeId: 2,
            title: 'Scrap Yard', //Industry Type Name
            locations: [
              {
                id: 'roger_scapyard',
                title: "Roger's Scrap Yard",
                x: -428.9064,
                y: -1728.5099,
              },
              {
                id: 'thomson_scrapyard',
                title: "Thomson's Scrap Yard",
                x: 2392.1606,
                y: 3121.2771,
              },
            ],
          },
          {
            typeId: 2,
            title: 'Scrap Yard', //Industry Type Name
            locations: [
              {
                id: 'roger_scapyard',
                title: "Roger's Scrap Yard",
                x: -428.9064,
                y: -1728.5099,
              },
              {
                id: 'thomson_scrapyard',
                title: "Thomson's Scrap Yard",
                x: 2392.1606,
                y: 3121.2771,
              },
            ],
          },
          {
            typeId: 2,
            title: 'Scrap Yard', //Industry Type Name
            locations: [
              {
                id: 'roger_scapyard',
                title: "Roger's Scrap Yard",
                x: -428.9064,
                y: -1728.5099,
              },
              {
                id: 'thomson_scrapyard',
                title: "Thomson's Scrap Yard",
                x: 2392.1606,
                y: 3121.2771,
              },
            ],
          },
          {
            typeId: 2,
            title: 'Scrap Yard', //Industry Type Name
            locations: [
              {
                id: 'roger_scapyard',
                title: "Roger's Scrap Yard",
                x: -428.9064,
                y: -1728.5099,
              },
              {
                id: 'thomson_scrapyard',
                title: "Thomson's Scrap Yard",
                x: 2392.1606,
                y: 3121.2771,
              },
            ],
          },
          {
            typeId: 2,
            title: 'Scrap Yard', //Industry Type Name
            locations: [
              {
                id: 'roger_scapyard',
                title: "Roger's Scrap Yard",
                x: -428.9064,
                y: -1728.5099,
              },
              {
                id: 'thomson_scrapyard',
                title: "Thomson's Scrap Yard",
                x: 2392.1606,
                y: 3121.2771,
              },
            ],
          },
          {
            typeId: 2,
            title: 'Scrap Yard', //Industry Type Name
            locations: [
              {
                id: 'roger_scapyard',
                title: "Roger's Scrap Yard",
                x: -428.9064,
                y: -1728.5099,
              },
              {
                id: 'thomson_scrapyard',
                title: "Thomson's Scrap Yard",
                x: 2392.1606,
                y: 3121.2771,
              },
            ],
          },
          {
            typeId: 2,
            title: 'Scrap Yard', //Industry Type Name
            locations: [
              {
                id: 'roger_scapyard',
                title: "Roger's Scrap Yard",
                x: -428.9064,
                y: -1728.5099,
              },
              {
                id: 'thomson_scrapyard',
                title: "Thomson's Scrap Yard",
                x: 2392.1606,
                y: 3121.2771,
              },
            ],
          },
          {
            typeId: 2,
            title: 'Scrap Yard', //Industry Type Name
            locations: [
              {
                id: 'roger_scapyard',
                title: "Roger's Scrap Yard",
                x: -428.9064,
                y: -1728.5099,
              },
              {
                id: 'thomson_scrapyard',
                title: "Thomson's Scrap Yard",
                x: 2392.1606,
                y: 3121.2771,
              },
            ],
          },
          {
            typeId: 2,
            title: 'Scrap Yard', //Industry Type Name
            locations: [
              {
                id: 'roger_scapyard',
                title: "Roger's Scrap Yard",
                x: -428.9064,
                y: -1728.5099,
              },
              {
                id: 'thomson_scrapyard',
                title: "Thomson's Scrap Yard",
                x: 2392.1606,
                y: 3121.2771,
              },
            ],
          },
        ],
      }
    );
    setIndustryListData(industries);
    setPDAVisible(PDAVisibilityType.IndustryList);
  };

  const selectVehicleCapacity = async () => {
    playClick();
    if (vehicleList.length <= 0) {
      const vehList = await fetchNui('loadVehicleCapacityList', {}, [
        {
          image: 'burrito',
          name: 'Burrito',
          capacity: 15,
          transType: 'crate',
          level: 1,
        },
        {
          image: 'mule',
          name: 'Mule',
          capacity: 35,
          transType: 'crate, pallet',
          level: 1,
        },
        {
          image: 'mule',
          name: 'Mule',
          capacity: 35,
          transType: 'crate, pallet',
          level: 1,
        },
        {
          image: 'mule',
          name: 'Mule',
          capacity: 35,
          transType: 'crate, pallet',
          level: 1,
        },
        {
          image: 'mule',
          name: 'Mule',
          capacity: 35,
          transType: 'crate, pallet',
          level: 1,
        },
        {
          image: 'mule',
          name: 'Mule',
          capacity: 35,
          transType: 'crate, pallet',
          level: 1,
        },
        {
          image: 'mule',
          name: 'Mule',
          capacity: 35,
          transType: 'crate, pallet',
          level: 1,
        },
        {
          image: 'mule',
          name: 'Mule',
          capacity: 35,
          transType: 'crate, pallet',
          level: 1,
        },
        {
          image: 'mule',
          name: 'Mule',
          capacity: 35,
          transType: 'crate, pallet',
          level: 1,
        },
      ]);
      setVehicleList(vehList);
    }
    setPDAVisible(PDAVisibilityType.VehicleCapacityList);
  };

  const numFormaterCompact = Intl.NumberFormat('en', {
    notation: 'compact',
    maximumFractionDigits: 0,
    minimumFractionDigits: 0,
  });

  const formatNumber = (_number: number, isExp = false) => {
    if ((_number > 100000000 && !isExp) || (isExp && _number > 99999)) {
      return numFormaterCompact.format(_number);
    } else {
      return _number.toLocaleString('en-US');
    }
  };

  return (
    <Wrapper>
      <ContentWrapper>
        <StaticsCardWrapper>
          <StaticsCardTextWrapper>
            <p className="font-medium drop-shadow-sglow">{locale.total_profit}</p>
            <p className="text-2xl font-bold text-[#59ff95] drop-shadow-sglowhover">
              {formatNumber(truckerData.totalProfit)}
            </p>
          </StaticsCardTextWrapper>
          <img src={profitIcon} width="80vw" className="drop-shadow-sglowhover" />
        </StaticsCardWrapper>
        <StaticsCardWrapper>
          <StaticsCardTextWrapper>
            <p className="font-medium drop-shadow-sglow">{locale.total_package}</p>
            <p className="text-2xl font-bold text-[#59ff95] drop-shadow-sglowhover">
              {formatNumber(truckerData.totalPackage)}
            </p>
          </StaticsCardTextWrapper>
          <img src={deliveryIcon} width="80vw" className="drop-shadow-sglowhover" />
        </StaticsCardWrapper>
        <StaticsCardWrapper>
          <StaticsCardTextWrapper>
            <p className="font-medium drop-shadow-sglow">{locale.total_distance}</p>
            <p className="text-2xl font-bold text-[#59ff95] drop-shadow-sglowhover">
              {formatNumber(truckerData.totalDistance)}
            </p>
          </StaticsCardTextWrapper>
          <img src={distanceIcon} width="80vw" className="drop-shadow-sglowhover" />
        </StaticsCardWrapper>
        <RankCardWrapper>
          <div className="mr-2 flex items-center justify-end">
            <img
              src={'./images/' + getRankImage(truckerData.level) + '.svg'}
              width="60vw"
              className="justify-self-center drop-shadow-sglowhover"
            />
            <StaticsCardTextWrapper>
              <p className="text-md text-right font-normal drop-shadow-sglow">
                {locale[getRankLabel(truckerData.level)]}
              </p>
              <p className="text-right text-xl font-medium text-[#59ff95]">
                <span className="drop-shadow-sglowhover">{formatNumber(truckerData.exp, true)}</span>
                <span className="text-gray-400">/{formatNumber(truckerData.needExp, true)}</span>
              </p>
            </StaticsCardTextWrapper>
          </div>
          <div className="w-[3.5rem] justify-self-start drop-shadow-sglow">
            <CircularProgressbar
              value={(truckerData.exp / truckerData.needExp) * 100}
              text={truckerData.level.toString()}
              styles={{
                path: {
                  stroke: `#59ff95`,
                  transition: 'stroke-dashoffset 0.5s ease 0s',
                },
                trail: {
                  stroke: '#888888',
                },
                text: {
                  fill: '#59ff95',
                  fontSize: '2rem',
                },
              }}
            />
          </div>
        </RankCardWrapper>
      </ContentWrapper>
      <ContentWrapper className="cursor-pointer pb-6">
        <IndustryWrapper className="bg-primary-industries-bg" onClick={() => selectIndustryTier(IndustryTier.Primary)}>
          <div className="flex flex-row-reverse">
            <TotalLabel>
              {pdaData.totalPrimary} {locale.units.toUpperCase()}
            </TotalLabel>
          </div>
          <IndustryTypeWrapper>
            <IndustryTypeLabel>{locale.primary_industries}</IndustryTypeLabel>
            <IndustryTypeDesc>{locale.primary_industry_desc}</IndustryTypeDesc>
          </IndustryTypeWrapper>
        </IndustryWrapper>
        <IndustryWrapper
          className="bg-secondary-industries-bg"
          onClick={() => selectIndustryTier(IndustryTier.Secondary)}
        >
          <div className="flex flex-row-reverse">
            <TotalLabel>
              {pdaData.totalSecondary} {locale.units.toUpperCase()}
            </TotalLabel>
          </div>
          <IndustryTypeWrapper>
            <IndustryTypeLabel>{locale.secondary_industries}</IndustryTypeLabel>
            <IndustryTypeDesc>{locale.secondary_industry_desc}</IndustryTypeDesc>
          </IndustryTypeWrapper>
        </IndustryWrapper>
        <IndustryWrapper className="bg-businesses-bg" onClick={() => selectIndustryTier(IndustryTier.Business)}>
          <div className="flex flex-row-reverse">
            <TotalLabel>
              {pdaData.totalBusinesses} {locale.units.toUpperCase()}
            </TotalLabel>
          </div>
          <IndustryTypeWrapper>
            <IndustryTypeLabel>{locale.businesses}</IndustryTypeLabel>
            <IndustryTypeDesc>{locale.businesses_desc}</IndustryTypeDesc>
          </IndustryTypeWrapper>
        </IndustryWrapper>
        <IndustryWrapper className="bg-veh-capacities-bg" onClick={() => selectVehicleCapacity()}>
          <div className="flex flex-row-reverse">
            <TotalLabel>
              {pdaData.totalVehicleCargo} {locale.units.toUpperCase()}
            </TotalLabel>
          </div>
          <IndustryTypeWrapper>
            <IndustryTypeLabel>{locale.vehicles_capacity}</IndustryTypeLabel>
            <IndustryTypeDesc>{locale.vehicle_capacity_desc}</IndustryTypeDesc>
          </IndustryTypeWrapper>
        </IndustryWrapper>
      </ContentWrapper>
    </Wrapper>
  );
};

export default PDAStatics;

const Wrapper = tw.div`
  grid grid-rows-[6em_30em] gap-4
`;

const ContentWrapper = tw.div`
  grid grid-cols-4 gap-4
`;
// bg-black/70
const StaticsCardWrapper = tw.div`
  bg-black/70 shadow rounded-md flex items-center justify-end pr-7
`;

const RankCardWrapper = tw.div`
  grid grid-cols-[75%_25%] items-center justify-end rounded-md bg-black/70 shadow
`;

const StaticsCardTextWrapper = tw.div`
  text-white text-right tracking-wide
`;

const IndustryWrapper = tw.div`
  grid grid-rows-[48%_52.1%] rounded-md bg-primary-industries-bg shadow-xl hover:drop-shadow-sglowhover
`;

const IndustryTypeWrapper = tw.div`
  rounded-bl-md rounded-br-md bg-purple text-white
`;

const IndustryTypeLabel = tw.p`
  pl-2 pt-2 text-xl font-bold text-[#59ff95] drop-shadow-sglowhover
`;

const IndustryTypeDesc = tw.p`
  px-2 pb-2 text-left
`;

const TotalLabel = tw.div`
  mr-2 mt-2 h-[10%] w-[30%] rounded-md bg-black/70 text-center font-bold text-[#59ff95] drop-shadow-sglowhover
`;
