// gs_trucker/web/src/types/index.ts

export interface CarryData {
  isCarry: boolean,
  itemName: string,
  buyPrice: number,
  industryName: string,
}

export interface TrukerData {
  totalProfit: number,
  totalPackage: number,
  totalDistance: number,
  exp: number,
  needExp: number,
  level: number
}

export interface PDAData {
  totalPrimary: number,
  totalSecondary: number,
  totalBusinesses: number,
  totalVehicleCargo: number
}

export interface IndustryTradeData {
  name: string,
  label: string,
  price: number,
  production?: string,
  consumption?: string,
  inStock: number,
  unit: string,
  storageSize: number,
  buyFromInfo: string,
  sellToInfo: string,
}

export interface IndustryData {
  name: string,
  label: string,
  status: number,
  isPrimaryIndustry: boolean,
  isBusiness: boolean
}

export interface ModalData {
  type: number,
  title: string,
  description: string,
  extraArgs: any
}

export interface VehicleStorageItem {
  itemName: string,
  itemLabel: string,
  industryName: string,
  industryLabel: string,
  transUnit: string,
  buyPrice: number,
  amount: number,
  capacity: number
}
export interface VehicleStorage {
  vehEntity: number,
  maxCapacity: number,
  currentCapacity: number,
  transType: string,
  storage: VehicleStorageItem[]
}

export interface TruckerHandbookItem {
  title: string,
  description: string
}
export interface TruckerHandbook {
  title: string,
  handbook: TruckerHandbookItem[]
}

export interface TruckRentalData {
  id: string,
  title: string,
  description: string
}

export interface LocationData {
  id: string,
  title: string,
  x: number,
  y: number
}
export interface IndustryListData {
  typeId: number,
  title: string,
  locations: LocationData[]
}

export interface PDAIndustryData {
  tier: number,
  userCoord: {
      x: number,
      y: number
  }
  list: IndustryListData[]
}

export interface VehicleCapacity {
  image: string,
  name: string,
  capacity: number,
  transType: string,
  level: number,
}

export interface VehicleRentalInfo {
  title: string,
  capacity: number,
  transType: string,
  image: string,
  level: number,
  rentPrice: number,
  vehicleIndex: number,
  vehicleHash: any,
  rentPointId: string
}

export interface PlayerRentalInfo {
  level: number,
  money: number
}

export interface CompanyData {
  id: number;
  name: string;
  owner_identifier: string;
  balance: number;
  logo_url: string;
  level: number;
  reputation: number;
}

// Em gs_trucker/web/src/types/index.ts

export interface Employee {
  id: number;
  company_id: number;
  identifier: string;
  name: string;
  role: string;   // <-- ADICIONE OU CORRIJA ESTA LINHA
  is_npc: boolean; // <-- ADICIONE ESTA LINHA
  salary: number; // Este já deve existir
}

export interface FleetVehicle {
  id: number;
  company_id: number;
  vehicle_plate: string;
  vehicle_model: string;
  status: string;
  maintenance: number;
 rent_expires_at?: string; // <-- Adicione esta linha
}

export interface Transaction {
    id: number;
    company_id: number;
    type: string;
    amount: number;
    description: string;
    timestamp: string;
}
export interface CompanyEmployee {
  id: number;
  company_id: number;
  identifier: string;
  name: string;
  is_npc: boolean;
  rank: string;
  hired_at: string;
}

export interface CompanyFleetVehicle {
  id: number;
  company_id: number;
  vehicle_plate: string;
  vehicle_model: string;
  status: string;
  maintenance: number;
}

export interface CompanyTransaction {
  id: number;
  company_id: number;
  type: string;
  amount: number;
  description: string;
  timestamp: string;
}

export interface FullCompanyInfo {
  has_profile: boolean;
  profile_data?: any;
  company_data?: CompanyData | null;
  employees?: Employee[];
  fleet?: FleetVehicle[]; // <-- ALTERE DE any[] PARA FleetVehicle[]
  transactions?: CompanyTransaction[];
  is_owner?: boolean;
  player_role?: string;
}

export interface ProfileData {
  id: number;
  identifier: string;
  profile_name: string;
  profile_picture: string;
  created_at: string;
}

// Adicionado para a Agência de Recrutamento
export type PostType = 'LOOKING_FOR_JOB' | 'HIRING' | 'GIG_OFFER';

export interface RecruitmentPost {
  id: number;
  author_identifier: string;
  author_name: string;
  author_avatar?: string | null; // <-- CORREÇÃO 1/3 AQUI
  post_type: PostType;
  title: string;
  content: string;
  company_id?: number;
  company_name?: string;
  company_logo?: string;
  gig_payment?: number;
  timestamp: string;
}

export interface Application {
  id: number;
  company_id: number;
  post_id: number;
  applicant_identifier: string;
  applicant_name: string;
  applicant_avatar?: string | null; // <-- CORREÇÃO 2/3 AQUI
  job_title: string;
  status: 'PENDING' | 'ACCEPTED' | 'REJECTED';
  timestamp: string;
}

export interface Chat {
  id: number;
  post_id: number;
  post_title: string;
  partner_name: string;
  partner_avatar?: string | null; // <-- CORREÇÃO 3/3 AQUI
}

export interface ChatMessage {
  id: number;
  author_identifier: string;
  author_name: string;
  message: string;
  timestamp: string;
}

export interface CompanyData {
  id: number;
  name: string;
  owner_identifier: string;
  balance: number;
  logo_url: string;
  level: number;
  reputation: number;
  permissions?: string;
  salary_payment_enabled?: boolean;
  garage_location?: string; // <-- ADICIONE ESTA LINHA
}

export interface Industry {
  name: string;
  label: string;
  tier: number;
  status: number;
  ownerName?: string;
}

export interface FleetVehicle {
  id: number;
  company_id: number;
  plate: string;
  model: string;
  damage: string; // Será um JSON string
  status: string;
  last_driver: string | null;
}

// ADICIONE ESTA NOVA INTERFACE
export interface FleetLog {
    id: number;
    player_name: string;
    action: string;
    timestamp: string;
}