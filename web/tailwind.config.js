/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      dropShadow: {
        glow: [
          "0 0px 10px rgba(255,255, 255, 0.08)",
          "0 0px 10px rgba(255, 255,255, 0.06)"
        ],
        sglow: [
          "0 0px 20px rgba(255,255, 255, 0.35)",
          "0 0px 65px rgba(255, 255,255, 0.2)"
        ],
        sglowhover: [
          "0 0px 20px rgba(89, 255, 149, 0.35)",
          "0 0px 65px rgba(89, 255, 149, 0.2)"
        ]
    
      },
      fontFamily: {
        text: 'Roboto',
      },
      backgroundImage: {
        'primary-industries-bg': "url(../images/primary_industries_bg.png)",
        'secondary-industries-bg': "url(../images/secondary_industries_bg.png)",
        'businesses-bg': "url(../images/businesses_bg.png)",
        'veh-capacities-bg': "url(../images/veh_capacities_bg.png)",
        'map': "url(../images/map.png)",
        "purple": "url(../images/bg-purple.png)",
        "purple2": "url(../images/bg-purple2.png)",
        "sky": "url(../images/bg-sky.png)",
        "main-2": "url(../images/bg-main-2.png)",
        "tablet-frame": "url(../images/ifruit-air.png)", 
      },
      gridTemplateRows: {
        'trucker-pda': '5em 36em'
      },
    },
    fontFamily: {
      'akrobat': ['Akrobat', 'Courier', 'monospace'],
      'signpainter': 'Signpainter'
    }
  },
  plugins: [],
};
