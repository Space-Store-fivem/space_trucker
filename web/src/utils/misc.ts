
// Will return whether the current environment is in a regular browser
// and not CEF
export const isEnvBrowser = (): boolean => !(window as any).invokeNative;

const x_base = 378;
const y_base = 892;
const rate = 0.0626061952634134;

export const calculateMapPosX = (gameX: number) => {
  let pdaX = gameX * rate;
  pdaX = x_base - pdaX;

  return pdaX.toFixed(2);
};

export const calculateMapPosY = (gameY: number) => {
  let pdaY = gameY * rate;
  pdaY = y_base - pdaY;

  return pdaY.toFixed(2);
};
// Basic no operation function
export const noop = () => {};

export const getRankImage = (_level: number) => {
  let level = _level;
  if (level < 10) {
    // Courier Trainee
    return 'rank1';
  }
  if (level < 20) {
    // Courier
    return 'rank2';
  }
  if (level < 30) {
    return 'rank3';
  }
  if (level < 40) {
    return 'rank4';
  }
  if (level < 50) {
    return 'rank5';
  }
  return 'rank6';
};

export const getRankLabel = (_level: number) => {
  let level = _level
  if (level < 10) {
    return 'rank_courier_trainee';
  }
  if (level < 20) {
    return 'rank_courier';
  }
  if (level < 30) {
    return 'rank_pro_courier';
  }
  if (level < 40) {
    return 'rank_trucker_trainee';
  }
  if (level < 50) {
    return 'rank_trucker';
  }
  return 'rank_pro_trucker';
};