export enum NavigationRoute {
  DojoSdk = 'DojoSdk',
  Settings = 'Settings',
}

export type RootStackParamList = {
  [NavigationRoute.DojoSdk]: undefined;
  [NavigationRoute.Settings]: undefined;
};

declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootStackParamList {}
  }
}
