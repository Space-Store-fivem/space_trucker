import React, { Fragment, useState, useEffect } from 'react';
import { Tooltip } from 'react-tooltip';
import { Transition } from '@headlessui/react';
import { useLocales } from '../../providers/LocaleProvider';
import tw from 'tailwind-styled-components';
import useSound from 'use-sound';
import pinIcon from '@assets/images/icons/location_pin.svg';
import userPinIcon from '@assets/images/icons/location.svg';
import { calculateMapPosX, calculateMapPosY } from '../../utils/misc';
import { useIndustryListData } from '../../state/pda';
import { IndustryListData } from '../../types';
import { IndustryTier } from '../../utils/enum';
import IndustryInformation from '../components/IndustryInformation';
import { useIndustryDataState, useSetIndustryDataForSale, useSetIndustryDataWanted } from '../../state/industry';
import { fetchNui } from '../../utils/fetchNui';
import clickSfx from '@assets/sounds/gtaselect.mp3';
import clickSfx2 from '@assets/sounds/gtahover.wav';
const IndustryList: React.FC = () => {
  const { locale } = useLocales();
  const industryList = useIndustryListData();
  const setIndustryDataForSale = useSetIndustryDataForSale();
  const setIndustryDataWanted = useSetIndustryDataWanted();
  const [industryData, setIndustryData] = useIndustryDataState();

  const [selectIndustry, setSelectIndustry] = useState<IndustryListData>();
  const [isIndustryInformationOpen, setIndustryInformationOpen] = useState(false);
  const [playClick] = useSound(clickSfx, { volume: 0.25 });
  const [playClick2] = useSound(clickSfx2, { volume: 0.25 });
  const getLocationText = (number: number) => {
    if (number > 1) return locale.locations;
    return locale.location;
  };

  const getIndustryTierLabel = (tier: IndustryTier) => {
    if (tier === IndustryTier.Primary) return locale.primary_industries;
    else if (tier === IndustryTier.Secondary) return locale.secondary_industries;
    else if (tier === IndustryTier.Business) return locale.businesses;
  };

  const selectIndustryPoint = async (industryId: string) => {
    playClick();
    let data = await fetchNui(
      'loadIndustryInformation',
      { industryId: industryId },
      {
        industryData: {
          name: 'the_beacon_hill_eggs',
          label: 'The Beacon Hill Eggs',
          status: 1,
          isPrimaryIndustry: false,
          isBusiness: false,
        },
        industryDataForSale: [
          {
            name: 'meal',
            label: 'Meal',
            price: 100,
            production: '+10 per resources',
            inStock: 10,
            unit: 'crates',
            storageSize: 100,
            buyFromInfo: 'Farm',
            sellToInfo: 'Restaurant',
          },
        ],
        industryDataWanted: [
          {
            name: 'eggs',
            label: 'Eggs',
            price: 120,
            consumption: '-10',
            inStock: 50,
            unit: 'crates',
            storageSize: 100,
            buyFromInfo: 'Farm',
            sellToInfo: 'Restaurant',
          },
          {
            name: 'milk',
            label: 'Milk',
            price: 120,
            consumption: '-10',
            inStock: 50,
            unit: 'm3',
            storageSize: 100,
            buyFromInfo: 'Farm',
            sellToInfo: 'Restaurant',
          },
        ],
      }
    );

    setIndustryData(data.industryData);
    setIndustryDataForSale(data.industryDataForSale);
    setIndustryDataWanted(data.industryDataWanted);
    setIndustryInformationOpen(true);
  };

  return (
    <>
      <MainWrapper>
        <List>
          <ListHeader>{getIndustryTierLabel(industryList.tier)}</ListHeader>
          <ListItemWrapper>
            {industryList.list.map((data) => {
              return (
                <ListItem
                  className={selectIndustry && data.typeId === selectIndustry.typeId ? 'bg-neutral-700' : ''}
                  onClick={() => {
                    playClick2();
                    setSelectIndustry(data);
                  }}
                >
                  <ListItemName>
                    {data.title.toUpperCase()}
                  </ListItemName>
                  <ListItemLocation>
                    {data.locations.length} {getLocationText(data.locations.length).toUpperCase()}
                  </ListItemLocation>
                </ListItem>
              );
            })}
          </ListItemWrapper>
        </List>
        <Map className="rounded-br-xl rounded-tr-xl bg-map bg-cover">
          <MapPin
            data-tooltip-id="location-tooltip"
            data-tooltip-content={locale.you_are_here}
            style={{
              top: calculateMapPosX(industryList.userCoord.x).toString() + 'px',
              left: calculateMapPosY(industryList.userCoord.y).toString() + 'px',
            }}
          >
            <img src={userPinIcon} />
          </MapPin>
          {selectIndustry &&
            selectIndustry.locations.map((data) => {
              return (
                <MapPin
                  data-tooltip-id="location-tooltip"
                  data-tooltip-content={data.title}
                  style={{
                    top: calculateMapPosX(data.x).toString() + 'px',
                    left: calculateMapPosY(data.y).toString() + 'px',
                  }}
                  onClick={() => selectIndustryPoint(data.id)}
                >
                  <img src={pinIcon} />
                </MapPin>
              );
            })}

          <Tooltip id="location-tooltip" />
          <IndustryInformation
            isIndustryInformationOpen={isIndustryInformationOpen}
            setIndustryInformationOpen={setIndustryInformationOpen}
          />
        </Map>
      </MainWrapper>
    </>
  );
};

export default IndustryList;

const MainWrapper = tw.div`
  grid grid-cols-[25%_75%] bg-sky-900/20
`;

const List = tw.div`
  flex flex-col overflow-auto
`;

const ListHeader = tw.div`
  px-4 pt-2 font-bold text-white
`;

const ListItemWrapper = tw.div`
  flex flex-col gap-1 overflow-auto px-4 py-2
`;

const ListItem = tw.div`
  flex items-center justify-between rounded-sm bg-black/40 p-2
  hover:bg-black/70 cursor-pointer
`;

const ListItemName = tw.p`
  text-sm font-bold text-white
`;

const ListItemLocation = tw.p`
  text-xs font-medium text-green-300 bg-black/40 pl-1 pr-1 rounded
`;

const Map = tw.div`
`;

const MapPin = tw.div`
  absolute w-[1.5%] cursor-pointer hover:drop-shadow-sglowhover
`;
