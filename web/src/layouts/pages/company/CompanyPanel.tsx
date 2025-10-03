import React, { useState, useEffect } from 'react';
import { FullCompanyInfo } from '../../../types';
import HomeScreen from './HomeScreen';
import { CreateProfile } from './CreateProfile';
import { CreateCompany } from './CreateCompany';
import { Dashboard } from './Dashboard';
import { Employees } from './Employees';
import Fleet from './Fleet';
import { Finance } from './Finance';
import { Settings } from './Settings';
import { fetchNui } from '../../../utils/fetchNui';
import { RecruitmentAgency } from './RecruitmentAgency';
import { Industries } from './Industries';
import { TransportMissions } from './TransportMissions';
import { LogisticsHub } from './LogisticsHub';
import CompanyGPS from './CompanyGPS';
import { IndustryMonitor } from './IndustryMonitor';
import { ProfileManagement } from './ProfileManagement';
// ==================================================================
// ============ ✨ 1. IMPORTAR O NOVO PAINEL DE CARGAS ✨ ============
// ==================================================================
import { CargoPanel } from './CargoPanel';


const CompanyPanel: React.FC<{ data: FullCompanyInfo; updateCompanyData: (data: FullCompanyInfo) => void; }> = ({ data, updateCompanyData }) => {
  const [activeApp, setActiveApp] = useState(data.has_profile ? 'home' : 'createProfile');

  const handleRefresh = () => {
    fetchNui('forceRefreshData');
  };

  useEffect(() => {
    if (data.company_data && (activeApp === 'createCompany' || activeApp === 'createProfile')) {
      setActiveApp('home');
    }
    
    if (!data.company_data && activeApp === 'settings') {
        setActiveApp('home');
    }

    if (data.has_profile && activeApp === 'createProfile') {
        setActiveApp('home');
    }
  }, [data, activeApp]);

  const safeUpdateCompanyData = (newData: Partial<FullCompanyInfo>) => {
    const updatedData = {
      ...data,
      ...newData,
      company_data: {
        ...(data.company_data || {}),
        ...(newData.company_data || {}),
      },
    };
    updateCompanyData(updatedData as FullCompanyInfo);
  };

  const renderActiveApp = () => {
    const goBack = () => setActiveApp('home');

    if (!data.has_profile) {
      return <CreateProfile onSuccess={handleRefresh} />;
    }

    switch (activeApp) {
      case 'createCompany':
        return <CreateCompany onSuccess={handleRefresh} onClose={goBack} />;
      
      case 'home':
        return <HomeScreen 
          company={data.company_data} 
          profile={data.profile_data}
          isOwner={data.is_owner || false} 
          playerRole={data.player_role} 
          onAppSelect={setActiveApp} 
        />;
        
      case 'dashboard':
        return <Dashboard companyData={data} onBack={goBack} />;
      case 'recruitment':
        return <RecruitmentAgency companyData={data} onBack={goBack} />;
      
      case 'industries':
        return <Industries companyData={data.company_data!} onBack={goBack} onSuccess={handleRefresh} />;

      case 'missions':
        return <TransportMissions onBack={goBack} companyData={data} />;

      case 'logisticsHub':
        return <LogisticsHub onBack={goBack} />;

      case 'gps':
        return <CompanyGPS onBack={goBack} />;

      case 'employees':
        return <Employees companyData={data} updateCompanyData={safeUpdateCompanyData} onBack={goBack} />;
      case 'fleet':
        return <Fleet companyData={data} onBack={goBack} onSuccess={handleRefresh} />;
      case 'finance':
        return <Finance companyData={data} updateCompanyData={safeUpdateCompanyData} onBack={goBack} />;
      case 'settings':
        return <Settings companyData={data} updateCompanyData={safeUpdateCompanyData} onBack={goBack} onSuccess={handleRefresh} />;
      
      case 'industryMonitor':
        return <IndustryMonitor onBack={goBack} />;

      case 'profile':
        return <ProfileManagement onBack={goBack} profile={data.profile_data || null} />;

      // ==================================================================
      // ========= ✨ 2. ADICIONAR O CASE PARA O PAINEL DE CARGAS ✨ ========
      // ==================================================================
      case 'cargo_panel':
        return <CargoPanel onBack={goBack} />;
        
      default:
        return <HomeScreen 
            company={data.company_data} 
            profile={data.profile_data}
            isOwner={data.is_owner || false} 
            playerRole={data.player_role} 
            onAppSelect={setActiveApp} 
        />;
    }
  };

  return (
    <div className="flex items-center justify-center h-screen w-screen font-sans">
      <div className="relative w-[90vw] h-[90vh] max-w-[1400px] max-h-[900px]">
        <div className="absolute w-[79.6%] h-[87.5%] top-[5.3%] left-[10%] bg-gray-900 rounded-2xl shadow-inner flex overflow-hidden z-10">
          {renderActiveApp()}
        </div>
        <img 
          src="images/ifruit-air.png" 
          alt="Moldura do Tablet" 
          className="absolute top-0 left-0 w-full h-full object-contain z-20 pointer-events-none" 
        />
      </div>
    </div>
  );
}

export default CompanyPanel;
